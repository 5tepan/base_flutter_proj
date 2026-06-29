import 'package:base_flutter_proj/core/base/base_api/entities/api_response_meta.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_api_response.g.dart';

@JsonSerializable()
class BaseApiResponse {
  ApiResponseMeta? meta;
  String? rawData;
  AppErrorCode? errorCode;
  String? serverMessage;
  dynamic dataJson;

  BaseApiResponse({
    this.meta,
    this.rawData,
    this.errorCode,
    this.serverMessage,
    this.dataJson,
  });

  bool get isError =>
      errorCode != null || (serverMessage != null && serverMessage!.isNotEmpty);
}
