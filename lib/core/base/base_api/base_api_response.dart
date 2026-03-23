class BaseApiResponse {
  ApiResponseMeta? meta;
  String? rawData;
  String? error;
  dynamic dataJson;

  BaseApiResponse({this.meta, this.rawData, this.error, this.dataJson});

  bool get isError => error != null;
}

class ApiResponseMeta {
  final String? error;
  final bool? invalidAccessToken;
  final bool? success;

  ApiResponseMeta({this.error, this.invalidAccessToken, this.success});

  factory ApiResponseMeta.fromJson(Map<String, dynamic> json) {
    return ApiResponseMeta(
      error: json['error'] as String,
      invalidAccessToken: json['invalidAccessToken'] as bool?,
      success: json['success'] as bool?,
    );
  }
}
