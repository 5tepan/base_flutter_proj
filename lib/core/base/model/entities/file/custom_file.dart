import 'package:base_flutter_proj/core/base/base_api/custom_json_formatters.dart';
import 'package:base_flutter_proj/core/base/model/entities/file/video_file.dart';
import 'package:cross_file/cross_file.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'custom_file.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class CustomFile {
  int? id;
  String? url;
  String? fullSize;
  String? name;
  MediaType? type;
  String? mimeType;
  String? originalName;
  String? previewUrl;
  String? blurHash;
  int? width;
  int? height;
  int? previewWidth;
  int? previewHeight;
  DateTime? createdAt;
  DateTime? updatedAt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  XFile? file;
  VideoFile? videoFile;

  CustomFile({this.file, this.url});

  bool get hasLocalFile => file != null;

  bool get hasRemoteUrl => displayUrl?.isNotEmpty ?? false;

  String? get displayUrl {
    if (url?.isNotEmpty ?? false) return url;
    if (previewUrl?.isNotEmpty ?? false) return previewUrl;
    if (fullSize?.isNotEmpty ?? false) return fullSize;
    return null;
  }

  factory CustomFile.fromJson(Map<String, dynamic> json) =>
      _$CustomFileFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFileToJson(this);
}
