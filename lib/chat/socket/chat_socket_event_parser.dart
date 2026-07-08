import 'package:base_flutter_proj/chat/model/chat_message.dart';

abstract final class ChatSocketEventParser {
  static ChatMessage? parseMessage(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final nested = data['message'];
    if (nested is Map<String, dynamic>) {
      return ChatMessage.fromApiJson(nested);
    }

    if (data.containsKey('room_id') || data.containsKey('roomId')) {
      return ChatMessage.fromApiJson(data);
    }

    return null;
  }

  static String? parseRoomId(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final roomId = data['room_id'] ?? data['roomId'];
    if (roomId is String && roomId.isNotEmpty) {
      return roomId;
    }

    final nested = data['message'];
    if (nested is Map<String, dynamic>) {
      final nestedRoomId = nested['room_id'] ?? nested['roomId'];
      if (nestedRoomId is String && nestedRoomId.isNotEmpty) {
        return nestedRoomId;
      }
    }

    return null;
  }

  static String? parseUserId(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final userId = data['user_id'] ?? data['userId'];
    if (userId is String && userId.isNotEmpty) {
      return userId;
    }

    return null;
  }

  static String? parseUserName(Map<String, dynamic>? data) {
    if (data == null) {
      return null;
    }

    final userName = data['user_name'] ?? data['userName'];
    if (userName is String && userName.isNotEmpty) {
      return userName;
    }

    return null;
  }
}
