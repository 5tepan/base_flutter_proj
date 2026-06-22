import 'package:base_flutter_proj/core/errors/app_error_code.dart';

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

class ApiResponseMeta {
  final String? error;
  final bool? invalidAccessToken;
  final bool? success;

  ApiResponseMeta({this.error, this.invalidAccessToken, this.success});

  factory ApiResponseMeta.fromJson(Map<String, dynamic> json) {
    return ApiResponseMeta(
      error: json['error'] as String?,
      invalidAccessToken: json['invalidAccessToken'] as bool?,
      success: json['success'] as bool?,
    );
  }
}
