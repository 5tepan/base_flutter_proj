import 'dart:convert';

import 'package:base_flutter_proj/core/base/api/api_response.dart';
import 'package:base_flutter_proj/core/base/api/base_api_response.dart';
import 'package:base_flutter_proj/core/base/api/json_schema.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:http/http.dart' as http;

/// Утилитарный класс для парсинга ответа сервера.
/// Позволяет парсить список сущностей, возвращенных с сервера.
/// А также одну сущность, возвращенную с сервера.
class ApiResponseParser {
  static BaseApiResponse parseRawResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300) {
      return BaseApiResponse(
        error: 'Не удалось отправить запрос. Попробуйте еще раз',
        rawData: response.body,
      );
    }
    return _parseBody(response.body);
  }

  /// Парсинг списка объектов из результата выполненного запроса к API.
  static ApiResponse<List<T>> parseListFromResponse<T>(
    BaseApiResponse response, {
    required String key,
    required T Function(Map<String, dynamic>) fromJson,
    String? emptyError,
  }) {
    try {
      if (response.isError) {
        return ApiResponse.error(
          error: response.error!,
          baseApiResponse: response,
        );
      }

      final jsonData = (response.dataJson as Map?)?[key];
      if (jsonData == null) {
        return ApiResponse.error(
          error: emptyError ?? 'Данные не найдены',
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
        error: 'Произошла ошибка, Попробуйте позже.',
        baseApiResponse: response,
      );
    }
  }

  /// Парсинг одного объекта из результата выполненного запроса к API.
  static ApiResponse<T> parseObjectFromResponse<T>(
    BaseApiResponse response, {
    required T Function(Map<String, dynamic>) fromJson,
    String? key,
    String? emptyError,
  }) {
    try {
      if (response.isError) {
        return ApiResponse.error(
          error: response.error!,
          baseApiResponse: response,
        );
      }

      if (response.dataJson == null) {
        return ApiResponse.error(
          error: emptyError ?? 'Данные не найдены',
          baseApiResponse: response,
        );
      }

      final jsonData = (key?.isNotEmpty ?? false)
          ? (response.dataJson as Map)[key]
          : response.dataJson;
      if (jsonData == null) {
        return ApiResponse.error(
          error: emptyError ?? 'Данные не найдены',
          baseApiResponse: response,
        );
      }
      final object = fromJson(jsonData as JsonSchema);
      return ApiResponse(baseApiResponse: response, result: object);
    } catch (e, s) {
      CustomLogger.error('Parse list error', e, s);
      return ApiResponse.error(
        error: 'Произошла ошибка, Попробуйте позже.',
        baseApiResponse: response,
      );
    }
  }

  static BaseApiResponse _parseBody(String? body) {
    if (body == null) {
      return BaseApiResponse(error: 'Bad Request Format', rawData: body);
    }
    final dynamic responseJson = json.decode(body);
    if (responseJson is! Map<String, dynamic>) {
      return BaseApiResponse(
        error: 'Response is not valid json',
        rawData: body,
      );
    }
    final dataJson = responseJson['data'];
    final metaJson = responseJson['meta'];
    if (metaJson == null) {
      return BaseApiResponse(
        error: 'Не удалось получить meta часть запроса',
        rawData: body,
      );
    }
    if (dataJson == null) {
      return BaseApiResponse(
        error: 'Не удалось получить data часть запроса',
        rawData: body,
      );
    }
    try {
      final apiResponseMeta = ApiResponseMeta.fromJson(metaJson as JsonSchema);

      if (!(apiResponseMeta.success ?? false)) {
        return BaseApiResponse(
          error: apiResponseMeta.error,
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
        error: 'Не удалось разобрать meta часть запроса',
        rawData: body,
      );
    }
  }
}
