// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
  id: json['id'] as String,
  roomId: json['room_id'] as String,
  text: json['text'] as String,
  senderId: json['sender_id'] as String,
  createdAt: const DateTimeJsonConverter().fromJson(json['created_at']),
  senderName: json['sender_name'] as String?,
  isOutgoing: json['is_outgoing'] as bool? ?? false,
);

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'text': instance.text,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'created_at': const DateTimeJsonConverter().toJson(instance.createdAt),
      'is_outgoing': instance.isOutgoing,
    };
