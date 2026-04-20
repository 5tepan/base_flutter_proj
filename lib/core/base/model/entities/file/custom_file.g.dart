// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFile _$CustomFileFromJson(Map<String, dynamic> json) =>
    CustomFile(url: json['url'] as String?)
      ..id = (json['id'] as num?)?.toInt()
      ..fullSize = json['full_size'] as String?
      ..name = json['name'] as String?
      ..type = $enumDecodeNullable(_$MediaTypeEnumMap, json['type'])
      ..mimeType = json['mime_type'] as String?
      ..originalName = json['original_name'] as String?
      ..previewUrl = json['preview_url'] as String?
      ..blurHash = json['blur_hash'] as String?
      ..width = (json['width'] as num?)?.toInt()
      ..height = (json['height'] as num?)?.toInt()
      ..previewWidth = (json['preview_width'] as num?)?.toInt()
      ..previewHeight = (json['preview_height'] as num?)?.toInt()
      ..createdAt = const DateTimeJsonConverter().fromJson(json['created_at'])
      ..updatedAt = const DateTimeJsonConverter().fromJson(json['updated_at'])
      ..videoFile = json['video_file'] == null
          ? null
          : VideoFile.fromJson(json['video_file'] as Map<String, dynamic>);

Map<String, dynamic> _$CustomFileToJson(CustomFile instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'url': ?instance.url,
      'full_size': ?instance.fullSize,
      'name': ?instance.name,
      'type': ?_$MediaTypeEnumMap[instance.type],
      'mime_type': ?instance.mimeType,
      'original_name': ?instance.originalName,
      'preview_url': ?instance.previewUrl,
      'blur_hash': ?instance.blurHash,
      'width': ?instance.width,
      'height': ?instance.height,
      'preview_width': ?instance.previewWidth,
      'preview_height': ?instance.previewHeight,
      'created_at': ?const DateTimeJsonConverter().toJson(instance.createdAt),
      'updated_at': ?const DateTimeJsonConverter().toJson(instance.updatedAt),
      'video_file': ?instance.videoFile?.toJson(),
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.videoThumbnail: 'videoThumbnail',
};
