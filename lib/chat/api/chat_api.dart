import 'package:base_flutter_proj/chat/model/chat_message.dart';
import 'package:base_flutter_proj/chat/model/chat_room.dart';

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
}
