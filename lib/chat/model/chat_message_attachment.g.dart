// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageAttachment _$ChatMessageAttachmentFromJson(
  Map<String, dynamic> json,
) => ChatMessageAttachment(
  id: json['id'] as String,
  url: json['url'] as String,
  type: $enumDecode(_$ChatAttachmentTypeEnumMap, json['type']),
  thumbnailUrl: json['thumbnail_url'] as String?,
);

Map<String, dynamic> _$ChatMessageAttachmentToJson(
  ChatMessageAttachment instance,
) => <String, dynamic>{
  'id': instance.id,
  'url': instance.url,
  'type': _$ChatAttachmentTypeEnumMap[instance.type]!,
  'thumbnail_url': instance.thumbnailUrl,
};

const _$ChatAttachmentTypeEnumMap = {
  ChatAttachmentType.photo: 'photo',
  ChatAttachmentType.video: 'video',
  ChatAttachmentType.file: 'file',
};
