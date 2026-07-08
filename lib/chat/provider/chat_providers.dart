import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/api/chat_api_impl.dart';
import 'package:base_flutter_proj/chat/api/mock_chat_api.dart';
import 'package:base_flutter_proj/chat/repository/chat_repository.dart';
import 'package:base_flutter_proj/chat/socket/chat_socket_constants.dart';
import 'package:base_flutter_proj/core/providers/api_providers.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/websocket/client/mock_websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/provider/websocket_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatApiProvider = Provider<ChatApi>((ref) {
  final config = ref.watch(configProvider);
  if (config.useMockChatApi) {
    return MockChatApi(
      emitSocketEvent: (eventName, data) {
        final client = ref.read(webSocketClientProvider);
        if (client is MockWebSocketClient) {
          client.emitTestEvent(
            WebSocketChannelEvent(
              channel: ChatSocketChannels.message,
              event: eventName,
              data: data,
            ),
          );
        }
      },
    );
  }
  return ChatApiImpl(ref.watch(coreApiProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(chatApiProvider));
});
