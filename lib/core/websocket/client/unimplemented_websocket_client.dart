import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/websocket/client/websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_connection_state.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';

/// Заглушка до подключения Pusher или raw WebSocket транспорта.
class UnimplementedWebSocketClient implements WebSocketClient {
  @override
  Stream<WebSocketConnectionState> get connectionState =>
      const Stream.empty();

  @override
  Stream<WebSocketChannelEvent> get events => const Stream.empty();

  @override
  Future<void> connect({required String accessToken}) async {
    CustomLogger.warning(
      'WebSocket: real transport is not configured. '
      'Set USE_MOCK_WEBSOCKET=true or add a WebSocketClient implementation.',
    );
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> subscribe(WebSocketChannelSubscription subscription) async {}

  @override
  Future<void> unsubscribe(String channelName) async {}
}
