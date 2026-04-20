// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_preview_image_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoPreviewImageFile _$VideoPreviewImageFileFromJson(
  Map<String, dynamic> json,
) => VideoPreviewImageFile()
  ..url = json['url'] as String?
  ..previewUrl = json['preview_url'] as String?
  ..width = (json['width'] as num?)?.toInt()
  ..height = (json['height'] as num?)?.toInt()
  ..previewWidth = (json['preview_width'] as num?)?.toInt()
  ..previewHeight = (json['preview_height'] as num?)?.toInt();

Map<String, dynamic> _$VideoPreviewImageFileToJson(
  VideoPreviewImageFile instance,
) => <String, dynamic>{
  'url': ?instance.url,
  'preview_url': ?instance.previewUrl,
  'width': ?instance.width,
  'height': ?instance.height,
  'preview_width': ?instance.previewWidth,
  'preview_height': ?instance.previewHeight,
};
