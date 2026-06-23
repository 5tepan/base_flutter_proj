// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFile _$CustomFileFromJson(Map<String, dynamic> json) =>
    CustomFile(url: json['url'] as String?)
      ..id = (json['id'] as num?)?.toInt()
      ..fullSize = json['fullSize'] as String?
      ..name = json['name'] as String?
      ..type = const MediaTypeJsonConverter().fromJson(json['type'])
      ..mimeType = json['mimeType'] as String?
      ..originalName = json['originalName'] as String?
      ..previewUrl = json['previewUrl'] as String?
      ..blurHash = json['blurHash'] as String?
      ..width = (json['width'] as num?)?.toInt()
      ..height = (json['height'] as num?)?.toInt()
      ..previewWidth = (json['previewWidth'] as num?)?.toInt()
      ..previewHeight = (json['previewHeight'] as num?)?.toInt()
      ..createdAt = const DateTimeJsonConverter().fromJson(json['createdAt'])
      ..updatedAt = const DateTimeJsonConverter().fromJson(json['updatedAt'])
      ..videoFile = json['videoFile'] == null
          ? null
          : VideoFile.fromJson(json['videoFile'] as Map<String, dynamic>);

Map<String, dynamic> _$CustomFileToJson(CustomFile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'fullSize': instance.fullSize,
      'name': instance.name,
      'type': const MediaTypeJsonConverter().toJson(instance.type),
      'mimeType': instance.mimeType,
      'originalName': instance.originalName,
      'previewUrl': instance.previewUrl,
      'blurHash': instance.blurHash,
      'width': instance.width,
      'height': instance.height,
      'previewWidth': instance.previewWidth,
      'previewHeight': instance.previewHeight,
      'createdAt': const DateTimeJsonConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeJsonConverter().toJson(instance.updatedAt),
      'videoFile': instance.videoFile,
    };
