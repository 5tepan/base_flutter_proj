import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/websocket/client/websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_connection_state.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';

/// WebSocket support remains disabled on Web until the backend accepts browser
/// WebSocket authentication without custom headers.
class FastApiWebSocketClient implements WebSocketClient {
  FastApiWebSocketClient({required Config config});

  @override
  Stream<WebSocketConnectionState> get connectionState => const Stream.empty();

  @override
  Stream<WebSocketChannelEvent> get events => const Stream.empty();

  @override
  Future<void> connect({required String accessToken}) async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> subscribe(WebSocketChannelSubscription subscription) async {}

  @override
  Future<void> unsubscribe(String channelName) async {}

  void dispose() {}
}
