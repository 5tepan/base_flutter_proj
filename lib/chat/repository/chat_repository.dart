import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';

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
}
