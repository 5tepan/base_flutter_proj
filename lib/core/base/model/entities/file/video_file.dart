import 'package:base_flutter_proj/core/base/model/entities/file/video_preview_image_file.dart';
import 'package:cross_file/cross_file.dart';
import 'package:json_annotation/json_annotation.dart';

part 'video_file.g.dart';

@JsonSerializable()
class VideoFile {
  final int? videoId;
  final String? thumbnailUrl;
  final String? videoUrl;
  VideoPreviewImageFile? videoPreviewImageFile;
  int? width;
  int? height;
  num? duration;
  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? file;

  VideoFile({
    this.videoId,
    this.thumbnailUrl,
    this.videoUrl,
    this.videoPreviewImageFile,
    this.width,
    this.height,
    this.duration,
    this.file,
  });

  bool get hasLocalFile => file != null;

  bool get hasRemoteUrl => displayUrl?.isNotEmpty ?? false;

  String? get displayUrl {
    if (videoUrl?.isNotEmpty ?? false) return videoUrl;
    if (thumbnailUrl?.isNotEmpty ?? false) return thumbnailUrl;
    return null;
  }

  factory VideoFile.fromJson(Map<String, dynamic> json) =>
      _$VideoFileFromJson(json);

  Map<String, dynamic> toJson() => _$VideoFileToJson(this);
}
