import 'package:base_flutter_proj/chat/provider/chat_list_notifier.dart';
import 'package:base_flutter_proj/chat/provider/chat_messages_notifier.dart';
import 'package:base_flutter_proj/chat/socket/chat_socket_constants.dart';
import 'package:base_flutter_proj/chat/socket/chat_socket_event_parser.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatSocketModuleProvider = Provider<WebSocketHandlerModule>((ref) {
  return WebSocketHandlerModule(
    subscriptions: [
      WebSocketChannelSubscription(
        channelName: ChatSocketChannels.message,
        isPrivate: true,
        eventHandlers: {
          ChatSocketEvents.messageSent: (event) {
            _handleMessageSent(ref, event);
          },
          ChatSocketEvents.messageRead: (event) {
            _handleMessageRead(ref, event);
          },
        },
      ),
    ],
  );
});

void _handleMessageSent(Ref ref, WebSocketChannelEvent event) {
  final message = ChatSocketEventParser.parseMessage(event.data);
  if (message == null) {
    CustomLogger.warning('Chat socket: failed to parse message.sent: ${event.data}');
    return;
  }

  ref.read(chatListProvider.notifier).applyIncomingMessage(message);

  if (ref.exists(chatMessagesProvider(message.roomId))) {
    ref
        .read(chatMessagesProvider(message.roomId).notifier)
        .applyIncomingMessage(message);
  }
}

void _handleMessageRead(Ref ref, WebSocketChannelEvent event) {
  final roomId = ChatSocketEventParser.parseRoomId(event.data);
  if (roomId == null) {
    CustomLogger.warning('Chat socket: failed to parse message.read: ${event.data}');
    return;
  }

  ref.read(chatListProvider.notifier).applyMessageRead(roomId);
}
