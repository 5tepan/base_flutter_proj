import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';

class ChatRepository {
  ChatRepository(this._api);

  final ChatApi _api;

  Future<List<ChatRoom>> fetchRooms({
    required int page,
    required int pageSize,
  }) {
    return _api.fetchRooms(page: page, pageSize: pageSize);
  }

  Future<List<ChatMessage>> fetchMessages({
    required String roomId,
    required int page,
    required int pageSize,
  }) {
    return _api.fetchMessages(
      roomId: roomId,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<ChatMessage> sendMessage({
    required String roomId,
    required String text,
    required String clientMessageId,
    List<MediaFeedItem> attachments = const [],
  }) {
    return _api.sendMessage(
      roomId: roomId,
      text: text,
      clientMessageId: clientMessageId,
      attachments: attachments,
    );
  }

  Future<void> sendTypingIndicator({
    required String roomId,
    required bool isTyping,
  }) {
    return _api.sendTypingIndicator(roomId: roomId, isTyping: isTyping);
  }
}
