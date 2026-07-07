import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_connection_state.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';

/// Транспортный слой WebSocket. Реализации: [MockWebSocketClient], Pusher и др.
abstract interface class WebSocketClient {
  Stream<WebSocketConnectionState> get connectionState;

  Stream<WebSocketChannelEvent> get events;

  Future<void> connect({required String accessToken});

  Future<void> disconnect();

  Future<void> subscribe(WebSocketChannelSubscription subscription);

  Future<void> unsubscribe(String channelName);
}
