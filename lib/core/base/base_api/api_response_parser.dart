import 'dart:convert';

import 'package:base_flutter_proj/core/base/base_api/api_response.dart';
import 'package:base_flutter_proj/core/base/base_api/base_api_response.dart';
import 'package:base_flutter_proj/core/base/base_api/json_schema.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:http/http.dart' as http;

/// Утилитарный класс для парсинга ответа сервера.
class ApiResponseParser {
  static BaseApiResponse parseRawResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300) {
      return BaseApiResponse(
        errorCode: AppErrorCode.requestFailed,
        rawData: response.body,
      );
    }
    return _parseBody(response.body);
  }

  static ApiResponse<List<T>> parseListFromResponse<T>(
    BaseApiResponse response, {
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    AppErrorCode emptyErrorCode = AppErrorCode.dataNotFound,
  }) {
    try {
      if (response.isError) {
        return ApiResponse.error(
          errorCode: response.errorCode ?? AppErrorCode.requestFailed,
          serverMessage: response.serverMessage,
          baseApiResponse: response,
        );
      }

      final jsonData = (response.dataJson as Map?)?[key];
      if (jsonData == null) {
        return ApiResponse.error(
          errorCode: emptyErrorCode,
          baseApiResponse: response,
        );
      }
      final list = (jsonData as List<dynamic>)
          .map((e) => fromJson(e as JsonSchema))
          .toList();
      return ApiResponse(baseApiResponse: response, result: list);
    } catch (e, s) {
      CustomLogger.error('Parse list error', e, s);
      return ApiResponse.error(
        errorCode: AppErrorCode.parseError,
        baseApiResponse: response,
      );
    }
  }

  static ApiResponse<T> parseObjectFromResponse<T>(
    BaseApiResponse response, {
    required T Function(Map<String, dynamic>) fromJson,
    String? key,
    AppErrorCode emptyErrorCode = AppErrorCode.dataNotFound,
  }) {
    try {
      if (response.isError) {
        return ApiResponse.error(
          errorCode: response.errorCode ?? AppErrorCode.requestFailed,
          serverMessage: response.serverMessage,
          baseApiResponse: response,
        );
      }

      if (response.dataJson == null) {
        return ApiResponse.error(
          errorCode: emptyErrorCode,
          baseApiResponse: response,
        );
      }

      final jsonData = (key?.isNotEmpty ?? false)
          ? (response.dataJson as Map)[key]
          : response.dataJson;
      if (jsonData == null) {
        return ApiResponse.error(
          errorCode: emptyErrorCode,
          baseApiResponse: response,
        );
      }
      final object = fromJson(jsonData as JsonSchema);
      return ApiResponse(baseApiResponse: response, result: object);
    } catch (e, s) {
      CustomLogger.error('Parse object error', e, s);
      return ApiResponse.error(
        errorCode: AppErrorCode.parseError,
        baseApiResponse: response,
      );
    }
  }

  static BaseApiResponse _parseBody(String? body) {
    if (body == null) {
      return BaseApiResponse(
        errorCode: AppErrorCode.badRequestFormat,
        rawData: body,
      );
    }
    final dynamic responseJson = json.decode(body);
    if (responseJson is! Map<String, dynamic>) {
      return BaseApiResponse(
        errorCode: AppErrorCode.invalidJson,
        rawData: body,
      );
    }
    final dataJson = responseJson['data'];
    final metaJson = responseJson['meta'];
    if (metaJson == null) {
      return BaseApiResponse(
        errorCode: AppErrorCode.missingMeta,
        rawData: body,
      );
    }
    if (dataJson == null) {
      return BaseApiResponse(
        errorCode: AppErrorCode.missingData,
        rawData: body,
      );
    }
    try {
      final apiResponseMeta = ApiResponseMeta.fromJson(metaJson as JsonSchema);

      if (!(apiResponseMeta.success ?? false)) {
        return BaseApiResponse(
          errorCode: AppErrorCode.requestFailed,
          serverMessage: apiResponseMeta.error,
          meta: apiResponseMeta,
          rawData: body,
        );
      }

      return BaseApiResponse(
        dataJson: dataJson,
        meta: apiResponseMeta,
        rawData: body,
      );
    } catch (e) {
      return BaseApiResponse(
        errorCode: AppErrorCode.invalidMeta,
        rawData: body,
      );
    }
  }
}
