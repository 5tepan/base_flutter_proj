// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_preview_image_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPreviewImageFile _$VideoPreviewImageFileFromJson(
  Map<String, dynamic> json,
) => VideoPreviewImageFile()
  ..url = json['url'] as String?
  ..previewUrl = json['previewUrl'] as String?
  ..width = (json['width'] as num?)?.toInt()
  ..height = (json['height'] as num?)?.toInt()
  ..previewWidth = (json['previewWidth'] as num?)?.toInt()
  ..previewHeight = (json['previewHeight'] as num?)?.toInt();

Map<String, dynamic> _$VideoPreviewImageFileToJson(
  VideoPreviewImageFile instance,
) => <String, dynamic>{
  'url': instance.url,
  'previewUrl': instance.previewUrl,
  'width': instance.width,
  'height': instance.height,
  'previewWidth': instance.previewWidth,
  'previewHeight': instance.previewHeight,
};
