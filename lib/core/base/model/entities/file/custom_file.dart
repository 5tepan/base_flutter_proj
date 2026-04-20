import 'dart:io';

import 'package:base_flutter_proj/core/base/base_api/custom_json_formatters.dart';
import 'package:base_flutter_proj/core/base/model/entities/file/video_file.dart';
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
  File? file;
  VideoFile? videoFile;

  CustomFile({this.file, this.url});

  factory CustomFile.fromJson(Map<String, dynamic> json) =>
      _$CustomFileFromJson(json);

  Map<String, dynamic> toJson() => _$CustomFileToJson(this);
}
