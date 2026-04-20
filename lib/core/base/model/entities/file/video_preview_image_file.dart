import 'package:json_annotation/json_annotation.dart';

part 'video_preview_image_file.g.dart';

@JsonSerializable()
class VideoPreviewImageFile {
  String? url;
  String? previewUrl;
  int? width;
  int? height;
  int? previewWidth;
  int? previewHeight;

  VideoPreviewImageFile();

  factory VideoPreviewImageFile.fromJson(Map<String, dynamic> json) =>
      _$VideoPreviewImageFileFromJson(json);

  Map<String, dynamic> toJson() => _$VideoPreviewImageFileToJson(this);
}
