import 'dart:async';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/websocket/client/websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/handler/websocket_dispatcher.dart';
import 'package:base_flutter_proj/core/websocket/handler/websocket_registry.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_connection_state.dart';

class WebSocketService {
  WebSocketService({
    required WebSocketClient client,
    required WebSocketRegistry registry,
    required WebSocketDispatcher dispatcher,
    required Future<bool> Function() checkConnection,
  })  : _client = client,
        _registry = registry,
        _dispatcher = dispatcher,
        _checkConnection = checkConnection;

  final WebSocketClient _client;
  final WebSocketRegistry _registry;
  final WebSocketDispatcher _dispatcher;
  final Future<bool> Function() _checkConnection;

  StreamSubscription<dynamic>? _eventsSubscription;
  var _isConnecting = false;

  Stream<WebSocketConnectionState> get connectionState =>
      _client.connectionState;

  Future<void> connect({required String accessToken}) async {
    if (_isConnecting) {
      return;
    }

    if (!await _checkConnection()) {
      CustomLogger.warning('WebSocket connect skipped: no internet');
      return;
    }

    _isConnecting = true;
    try {
      await _client.disconnect();
      await _client.connect(accessToken: accessToken);
      await _eventsSubscription?.cancel();
      _eventsSubscription = _client.events.listen(_dispatcher.dispatch);

      for (final subscription in _registry.subscriptions) {
        await _client.subscribe(subscription);
      }
    } catch (error, stackTrace) {
      CustomLogger.warning('WebSocket connect failed', error, stackTrace);
    } finally {
      _isConnecting = false;
    }
  }

  Future<void> reconnect({required String accessToken}) async {
    await disconnect();
    await connect(accessToken: accessToken);
  }

  Future<void> disconnect() async {
    await _eventsSubscription?.cancel();
    _eventsSubscription = null;
    await _client.disconnect();
  }

  Future<void> dispose() async {
    await disconnect();
  }
}
