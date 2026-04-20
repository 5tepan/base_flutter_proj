// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoFile _$VideoFileFromJson(Map<String, dynamic> json) => VideoFile(
  videoId: (json['video_id'] as num?)?.toInt(),
  thumbnailUrl: json['thumbnail_url'] as String?,
  videoUrl: json['video_url'] as String?,
  videoPreviewImageFile: json['video_preview_image_file'] == null
      ? null
      : VideoPreviewImageFile.fromJson(
          json['video_preview_image_file'] as Map<String, dynamic>,
        ),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  duration: json['duration'] as num?,
);

Map<String, dynamic> _$VideoFileToJson(VideoFile instance) => <String, dynamic>{
  'video_id': ?instance.videoId,
  'thumbnail_url': ?instance.thumbnailUrl,
  'video_url': ?instance.videoUrl,
  'video_preview_image_file': ?instance.videoPreviewImageFile?.toJson(),
  'width': ?instance.width,
  'height': ?instance.height,
  'duration': ?instance.duration,
};
