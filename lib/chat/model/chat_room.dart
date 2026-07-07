import 'package:base_flutter_proj/core/base/base_api/custom_json_formatters.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_room.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ChatRoom {
  const ChatRoom({
    required this.id,
    required this.title,
    this.lastMessageText,
    this.lastMessageAt,
    this.unreadCount = 0,
    this.avatarUrl,
  });

  final String id;
  final String title;
  final String? lastMessageText;

  @DateTimeJsonConverter()
  final DateTime? lastMessageAt;

  final int unreadCount;
  final String? avatarUrl;

  factory ChatRoom.fromJson(Map<String, dynamic> json) => _$ChatRoomFromJson(json);

  Map<String, dynamic> toJson() => _$ChatRoomToJson(this);

  factory ChatRoom.fromApiJson(Map<String, dynamic> json) => ChatRoom.fromJson(json);
}
