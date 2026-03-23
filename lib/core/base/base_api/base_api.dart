import 'dart:convert';
import 'dart:io';

import 'package:base_flutter_proj/core/base/base_api/Interceptors/base_api_interceptor.dart';
import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/base/base_api/base_api_response.dart';
import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';

typedef ConnectivityCheck = Future<bool> Function();

abstract class BaseApi {
  final Config config;
  final PackageInfo packageInfo;
  final ConnectivityCheck checkConnection;

  BaseApi({
    required this.config,
    required this.packageInfo,
    required this.checkConnection,
  });

  bool isLoggerOutputEnabled = true;

  late final InterceptedClient client = InterceptedClient.build(
    interceptors: [
      BaseApiInterceptor(packageInfo: packageInfo),
      if (isLoggerOutputEnabled) CustomLogger.httpInterceptor,
    ],
  );

  @protected
  Future<Uri> buildUri({
    required String relativePath,
    Map<String, dynamic>? queryParameters,
  }) async {
    queryParameters ??= {};

    return config.isHttpsApi
        ? Uri.https(
            config.apiUrlDomain,
            config.apiUrlRelativePath + relativePath,
            queryParameters,
          )
        : Uri.http(
            config.apiUrlDomain,
            config.apiUrlRelativePath + relativePath,
            queryParameters,
          );
  }

  Map<String, String>? prepareParams(Map<String, dynamic>? params) {
    return params?.map((key, value) {
      if (value is String) return MapEntry(key, value);
      return MapEntry(key, jsonEncode(value));
    });
  }

  Future<BaseApiResponse> sendGetRequest(
    String relativePath, {
    Map<String, dynamic>? params,
  }) async {
    if (!await checkConnection()) {
      return BaseApiResponse(error: 'Нет интернета. Попробуйте позже.');
    }

    try {
      final uri = await buildUri(
        relativePath: relativePath,
        queryParameters: params?.map((k, v) => MapEntry(k, v.toString())),
      );

      final response = await client.get(uri);
      return parseResponse(response);
    } catch (error) {
      return processResponseError(
        error,
        Uri.parse(config.apiUrlDomain + relativePath),
      );
    }
  }

  Future<BaseApiResponse> sendPostRequest(
    String relativePath, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    if (!await checkConnection()) {
      return BaseApiResponse(error: 'Нет интернета. Попробуйте позже.');
    }

    try {
      final uri = await buildUri(relativePath: relativePath);
      final stringBody = body?.map((k, v) => MapEntry(k, v.toString()));
      final response = await client.post(
        uri,
        body: stringBody,
        headers: headers,
      );

      return parseResponse(response);
    } catch (error) {
      return processResponseError(
        error,
        Uri.parse(config.apiUrlDomain + relativePath),
      );
    }
  }

  Future<BaseApiResponse> sendPostRequestWithFiles(
    String relativePath,
    List<http.MultipartFile> files, [
    Map<String, dynamic>? params,
  ]) async {
    if (!await checkConnection()) {
      return BaseApiResponse(error: 'Нет интернета. Попробуйте позже.');
    }

    try {
      final uri = await buildUri(relativePath: relativePath);
      final request = http.MultipartRequest('POST', uri);

      if (params != null) {
        final stringParams = params.map(
          (key, value) => MapEntry(key, value.toString()),
        );
        request.fields.addAll(stringParams);
      }

      request.files.addAll(files);
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      return parseResponse(response);
    } catch (error) {
      return processResponseError(
        error,
        Uri.parse(config.apiUrlDomain + relativePath),
      );
    }
  }

  BaseApiResponse processResponseError(Object error, Uri uri) {
    String errorMessage;

    switch (error) {
      case String msg:
        errorMessage = msg;
      case SocketException _:
        errorMessage = 'Ошибка подключения к интернету';
      default:
        errorMessage = 'Неизвестная ошибка. Попробуйте позже';
        CustomLogger.error(error);
    }

    return BaseApiResponse(error: errorMessage);
  }

  @protected
  BaseApiResponse parseResponse(http.Response response) {
    if (isLoggerOutputEnabled) {
      CustomLogger.httpInterceptor.logResponse(response: response);
    }
    return ApiResponseParser.parseRawResponse(response);
  }
}
