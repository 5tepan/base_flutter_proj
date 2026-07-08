import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';

abstract class ChatApi {
  Future<List<ChatRoom>> fetchRooms({
    required int page,
    required int pageSize,
  });

  Future<List<ChatMessage>> fetchMessages({
    required String roomId,
    required int page,
    required int pageSize,
  });

  Future<ChatMessage> sendMessage({
    required String roomId,
    required String text,
    required String clientMessageId,
    List<MediaFeedItem> attachments = const [],
  });

  Future<void> sendTypingIndicator({
    required String roomId,
    required bool isTyping,
  });
}
