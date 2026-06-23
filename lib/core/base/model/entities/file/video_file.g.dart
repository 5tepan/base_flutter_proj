// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoFile _$VideoFileFromJson(Map<String, dynamic> json) => VideoFile(
  videoId: (json['videoId'] as num?)?.toInt(),
  thumbnailUrl: json['thumbnailUrl'] as String?,
  videoUrl: json['videoUrl'] as String?,
  videoPreviewImageFile: json['videoPreviewImageFile'] == null
      ? null
      : VideoPreviewImageFile.fromJson(
          json['videoPreviewImageFile'] as Map<String, dynamic>,
        ),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  duration: json['duration'] as num?,
);

Map<String, dynamic> _$VideoFileToJson(VideoFile instance) => <String, dynamic>{
  'videoId': instance.videoId,
  'thumbnailUrl': instance.thumbnailUrl,
  'videoUrl': instance.videoUrl,
  'videoPreviewImageFile': instance.videoPreviewImageFile,
  'width': instance.width,
  'height': instance.height,
  'duration': instance.duration,
};
