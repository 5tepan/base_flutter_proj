import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/websocket/client/websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_connection_state.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';
import 'package:http/http.dart' as http;

/// Raw JSON WebSocket transport for FastAPI backend (`/ws` + `/api/broadcasting/auth`).
class FastApiWebSocketClient implements WebSocketClient {
  FastApiWebSocketClient({required Config config}) : _config = config;

  final Config _config;

  final _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();
  final _eventsController = StreamController<WebSocketChannelEvent>.broadcast();
  final _subscriptions = <String, WebSocketChannelSubscription>{};

  WebSocket? _socket;
  StreamSubscription<dynamic>? _socketSubscription;
  String? _socketId;
  String? _accessToken;
  Completer<void>? _handshakeCompleter;
  var _isConnected = false;

  @override
  Stream<WebSocketConnectionState> get connectionState =>
      _connectionStateController.stream;

  @override
  Stream<WebSocketChannelEvent> get events => _eventsController.stream;

  @override
  Future<void> connect({required String accessToken}) async {
    if (_isConnected) {
      return;
    }

    _accessToken = accessToken;
    _connectionStateController.add(WebSocketConnectionState.connecting);
    _handshakeCompleter = Completer<void>();

    try {
      final uri = _buildWebSocketUri(accessToken);
      final socket = await WebSocket.connect(uri.toString());
      _socket = socket;
      _socketSubscription = socket.listen(
        _onSocketData,
        onDone: _handleSocketClosed,
        onError: (Object error, StackTrace stackTrace) {
          CustomLogger.warning('WebSocket error', error, stackTrace);
          _handleSocketClosed();
        },
      );
      await _handshakeCompleter!.future.timeout(const Duration(seconds: 5));
      _isConnected = true;
      _connectionStateController.add(WebSocketConnectionState.connected);
      CustomLogger.info('FastApiWebSocketClient connected: $uri');
    } catch (error, stackTrace) {
      _handshakeCompleter = null;
      _connectionStateController.add(WebSocketConnectionState.disconnected);
      CustomLogger.warning('WebSocket connect failed', error, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_isConnected && _socket == null) {
      return;
    }

    await _socketSubscription?.cancel();
    _socketSubscription = null;
    await _socket?.close();
    _socket = null;
    _socketId = null;
    _accessToken = null;
    _handshakeCompleter = null;
    _subscriptions.clear();
    _isConnected = false;
    _connectionStateController.add(WebSocketConnectionState.disconnected);
    CustomLogger.info('FastApiWebSocketClient disconnected');
  }

  @override
  Future<void> subscribe(WebSocketChannelSubscription subscription) async {
    _subscriptions[subscription.channelName] = subscription;

    if (!_isConnected || _socket == null) {
      return;
    }

    String? auth;
    if (subscription.isPrivate) {
      auth = await _authorizePrivateChannel(subscription.channelName);
      if (auth == null) {
        CustomLogger.warning(
          'WebSocket private channel auth failed: ${subscription.channelName}',
        );
        return;
      }
    }

    _send({
      'action': 'subscribe',
      'channel': subscription.channelName,
      if (subscription.isPrivate) 'private': true,
      if (auth != null) 'auth': auth,
    });
    CustomLogger.info(
      'FastApiWebSocketClient subscribed: ${subscription.channelName}',
    );
  }

  @override
  Future<void> unsubscribe(String channelName) async {
    _subscriptions.remove(channelName);
    if (_socket == null) {
      return;
    }

    _send({'action': 'unsubscribe', 'channel': channelName});
    CustomLogger.info('FastApiWebSocketClient unsubscribed: $channelName');
  }

  void dispose() {
    unawaited(disconnect());
    unawaited(_connectionStateController.close());
    unawaited(_eventsController.close());
  }

  Uri _buildWebSocketUri(String accessToken) {
    final host = _resolveHost();
    final port = _resolvePort(host);
    final scheme = _config.isHttpsApi ? 'wss' : 'ws';

    return Uri(
      scheme: scheme,
      host: _stripPort(host),
      port: port,
      path: '/ws',
      queryParameters: {'token': accessToken},
    );
  }

  Uri _buildAuthUri() {
    final host = _resolveHost();
    final port = _resolvePort(host);
    final scheme = _config.isHttpsApi ? 'https' : 'http';
    final path = _config.webSocketAuthRelativePath.startsWith('/')
        ? _config.webSocketAuthRelativePath
        : '/${_config.webSocketAuthRelativePath}';

    return Uri(scheme: scheme, host: _stripPort(host), port: port, path: path);
  }

  String _resolveHost() {
    final configured = _config.webSocketHost?.trim();
    if (configured != null && configured.isNotEmpty) {
      return configured;
    }
    return _config.apiUrlDomain;
  }

  int _resolvePort(String host) {
    final configured = _config.webSocketPort;
    if (configured != null) {
      return configured;
    }

    if (host.contains(':')) {
      final parsed = Uri.tryParse('//$host');
      if (parsed != null && parsed.hasPort) {
        return parsed.port;
      }
    }

    return _config.isHttpsApi ? 443 : 8000;
  }

  String _stripPort(String host) {
    final uri = Uri.tryParse('//$host');
    if (uri == null || uri.host.isEmpty) {
      return host.split(':').first;
    }
    return uri.host;
  }

  Future<String?> _authorizePrivateChannel(String channelName) async {
    final accessToken = _accessToken;
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final response = await http.post(
      _buildAuthUri(),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode({
        'channel_name': 'private-$channelName',
        'socket_id': _socketId ?? '',
      }),
    );

    if (response.statusCode != 200) {
      return null;
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      return null;
    }

    final data = body['data'];
    if (data is Map<String, dynamic>) {
      final auth = data['auth'];
      if (auth is String && auth.isNotEmpty) {
        return auth;
      }
    }

    final directAuth = body['auth'];
    if (directAuth is String && directAuth.isNotEmpty) {
      return directAuth;
    }

    return null;
  }

  void _send(Map<String, dynamic> payload) {
    final socket = _socket;
    if (socket == null) {
      return;
    }
    socket.add(jsonEncode(payload));
  }

  void _onSocketData(dynamic data) {
    if (data is! String) {
      return;
    }

    final decoded = jsonDecode(data);
    if (decoded is! Map<String, dynamic>) {
      return;
    }

    final type = decoded['type'];
    if (type == 'connected') {
      final socketId = decoded['socket_id'];
      if (socketId is String) {
        _socketId = socketId;
      }
      _handshakeCompleter?.complete();
      _handshakeCompleter = null;
      return;
    }

    if (type == 'event') {
      final channel = decoded['channel'];
      final event = decoded['event'];
      if (channel is! String || event is! String) {
        return;
      }

      final rawData = decoded['data'];
      _eventsController.add(
        WebSocketChannelEvent(
          channel: channel,
          event: event,
          data: rawData is Map<String, dynamic> ? rawData : null,
        ),
      );
      return;
    }

    if (type == 'error') {
      CustomLogger.warning('WebSocket server error: ${decoded['message']}');
    }
  }

  void _handleSocketClosed() {
    if (!_isConnected && _handshakeCompleter != null) {
      _handshakeCompleter?.completeError(StateError('socketClosed'));
      _handshakeCompleter = null;
      return;
    }
    if (!_isConnected) {
      return;
    }
    _isConnected = false;
    _socket = null;
    _socketId = null;
    _connectionStateController.add(WebSocketConnectionState.disconnected);
  }
}
