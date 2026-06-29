import 'package:json_annotation/json_annotation.dart';

part 'api_response_meta.g.dart';

@JsonSerializable()
class ApiResponseMeta {
  const ApiResponseMeta({this.error, this.invalidAccessToken, this.success});

  final String? error;
  final bool? invalidAccessToken;
  final bool? success;

  factory ApiResponseMeta.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ApiResponseMetaToJson(this);
}
