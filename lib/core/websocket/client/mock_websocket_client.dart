import 'dart:async';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/websocket/client/websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_connection_state.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';

/// Mock-клиент для dev без бэкенда.
class MockWebSocketClient implements WebSocketClient {
  final _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();
  final _eventsController = StreamController<WebSocketChannelEvent>.broadcast();
  final _subscriptions = <String, WebSocketChannelSubscription>{};

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

    _connectionStateController.add(WebSocketConnectionState.connecting);
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _isConnected = true;
    _connectionStateController.add(WebSocketConnectionState.connected);
    CustomLogger.info('MockWebSocketClient connected');
  }

  @override
  Future<void> disconnect() async {
    if (!_isConnected) {
      return;
    }

    _subscriptions.clear();
    _isConnected = false;
    _connectionStateController.add(WebSocketConnectionState.disconnected);
    CustomLogger.info('MockWebSocketClient disconnected');
  }

  @override
  Future<void> subscribe(WebSocketChannelSubscription subscription) async {
    _subscriptions[subscription.channelName] = subscription;
    CustomLogger.info(
      'MockWebSocketClient subscribed: ${subscription.channelName} '
      '(private=${subscription.isPrivate}, '
      'events=${subscription.eventHandlers.keys.join(', ')})',
    );
  }

  @override
  Future<void> unsubscribe(String channelName) async {
    _subscriptions.remove(channelName);
    CustomLogger.info('MockWebSocketClient unsubscribed: $channelName');
  }

  /// Эмуляция входящего события (для тестов и dev).
  void emitTestEvent(WebSocketChannelEvent event) {
    if (!_isConnected) {
      return;
    }
    _eventsController.add(event);
  }

  void dispose() {
    unawaited(disconnect());
    unawaited(_connectionStateController.close());
    unawaited(_eventsController.close());
  }
}
