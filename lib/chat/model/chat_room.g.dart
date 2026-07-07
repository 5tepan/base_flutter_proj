// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoom _$ChatRoomFromJson(Map<String, dynamic> json) => ChatRoom(
  id: json['id'] as String,
  title: json['title'] as String,
  lastMessageText: json['last_message_text'] as String?,
  lastMessageAt: const DateTimeJsonConverter().fromJson(
    json['last_message_at'],
  ),
  unreadCount: (json['unread_count'] as num?)?.toInt() ?? 0,
  avatarUrl: json['avatar_url'] as String?,
);

Map<String, dynamic> _$ChatRoomToJson(ChatRoom instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'last_message_text': instance.lastMessageText,
  'last_message_at': const DateTimeJsonConverter().toJson(
    instance.lastMessageAt,
  ),
  'unread_count': instance.unreadCount,
  'avatar_url': instance.avatarUrl,
};
