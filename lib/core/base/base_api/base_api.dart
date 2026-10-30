import 'dart:convert';
import 'dart:io';

import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/base/base_api/entities/base_api_response.dart';
import 'package:base_flutter_proj/core/base/base_api/interceptors/base_api_interceptor.dart';
import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';
import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';

typedef ConnectivityCheck = Future<bool> Function();

abstract class BaseApi {
  final Config config;
  final PackageInfo packageInfo;
  final ConnectivityCheck checkConnection;
  final AuthTokenHolder? tokenHolder;
  final Future<bool> Function()? onRefreshToken;

  BaseApi({
    required this.config,
    required this.packageInfo,
    required this.checkConnection,
    this.tokenHolder,
    this.onRefreshToken,
    bool enableHttpLogs = false,
  }) : isLoggerOutputEnabled = enableHttpLogs;

  final bool isLoggerOutputEnabled;

  late final InterceptedClient client = InterceptedClient.build(
    client: config.useFakeApi
        ? FakeApiClient(apiRelativePath: config.apiUrlRelativePath)
        : null,
    interceptors: [
      BaseApiInterceptor(
        packageInfo: packageInfo,
        tokenHolder: tokenHolder,
      ),
      if (isLoggerOutputEnabled) CustomLogger.httpInterceptor,
    ],
  );

  Future<bool> _hasConnection() async {
    if (config.useFakeApi) {
      return true;
    }
    return checkConnection();
  }

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

  /// Строки, числа и bool уходят как есть. Вложенные структуры — JSON,
  /// а не `toString()` у Map.
  Map<String, String>? encodeFields(Map<String, dynamic>? params) {
    return params?.map((key, value) {
      if (value == null) return MapEntry(key, '');
      if (value is String) return MapEntry(key, value);
      if (value is num || value is bool) return MapEntry(key, '$value');
      return MapEntry(key, jsonEncode(value));
    });
  }

  Uri _fallbackUri(String relativePath) {
    final path = config.apiUrlRelativePath + relativePath;
    return config.isHttpsApi
        ? Uri.https(config.apiUrlDomain, path)
        : Uri.http(config.apiUrlDomain, path);
  }

  Future<BaseApiResponse> sendGetRequest(
    String relativePath, {
    Map<String, dynamic>? params,
  }) async {
    return _withUnauthorizedRetry(() async {
      if (!await _hasConnection()) {
        return BaseApiResponse(errorCode: AppErrorCode.noInternet);
      }

      Uri? uri;
      try {
        uri = await buildUri(
          relativePath: relativePath,
          queryParameters: encodeFields(params),
        );

        final response = await client.get(uri);
        return parseResponse(response);
      } catch (error) {
        return processResponseError(error, uri ?? _fallbackUri(relativePath));
      }
    });
  }

  Future<BaseApiResponse> sendPostRequest(
    String relativePath, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _withUnauthorizedRetry(() async {
      if (!await _hasConnection()) {
        return BaseApiResponse(errorCode: AppErrorCode.noInternet);
      }

      Uri? uri;
      try {
        uri = await buildUri(relativePath: relativePath);
        final response = await client.post(
          uri,
          body: encodeFields(body),
          headers: headers,
        );

        return parseResponse(response);
      } catch (error) {
        return processResponseError(error, uri ?? _fallbackUri(relativePath));
      }
    });
  }

  Future<BaseApiResponse> sendPostJsonRequest(
    String relativePath, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    return _withUnauthorizedRetry(() async {
      if (!await _hasConnection()) {
        return BaseApiResponse(errorCode: AppErrorCode.noInternet);
      }

      Uri? uri;
      try {
        uri = await buildUri(relativePath: relativePath);
        final requestHeaders = {
          'Content-Type': 'application/json',
          ...?headers,
        };
        final response = await client.post(
          uri,
          headers: requestHeaders,
          body: body == null ? null : jsonEncode(body),
        );

        return parseResponse(response);
      } catch (error) {
        return processResponseError(error, uri ?? _fallbackUri(relativePath));
      }
    });
  }

  Future<BaseApiResponse> sendPostRequestWithFiles(
    String relativePath,
    List<http.MultipartFile> files, [
    Map<String, dynamic>? params,
  ]) async {
    return _withUnauthorizedRetry(() async {
      if (!await _hasConnection()) {
        return BaseApiResponse(errorCode: AppErrorCode.noInternet);
      }

      Uri? uri;
      try {
        uri = await buildUri(relativePath: relativePath);
        final request = http.MultipartRequest('POST', uri);
        final fields = encodeFields(params);
        if (fields != null) {
          request.fields.addAll(fields);
        }

        request.files.addAll(files);
        final streamedResponse = await client.send(request);
        final response = await http.Response.fromStream(streamedResponse);

        return parseResponse(response);
      } catch (error) {
        return processResponseError(error, uri ?? _fallbackUri(relativePath));
      }
    });
  }

  Future<BaseApiResponse> _withUnauthorizedRetry(
    Future<BaseApiResponse> Function() send,
  ) async {
    final response = await send();
    if (!_shouldRefreshToken(response)) {
      return response;
    }

    final refresh = onRefreshToken;
    if (refresh == null) {
      return response;
    }

    final refreshed = await refresh();
    if (!refreshed) {
      return response;
    }

    return send();
  }

  bool _shouldRefreshToken(BaseApiResponse response) {
    if (response.statusCode == 401) {
      return true;
    }
    if (response.meta?.invalidAccessToken == true) {
      return true;
    }

    final raw = response.rawData;
    if (raw == null || response.errorCode != AppErrorCode.requestFailed) {
      return false;
    }
    return raw.contains('invalidAccessToken') ||
        raw.contains('invalid_access_token');
  }

  BaseApiResponse processResponseError(Object error, Uri uri) {
    switch (error) {
      case String msg:
        return BaseApiResponse(serverMessage: msg);
      case SocketException _:
        return BaseApiResponse(errorCode: AppErrorCode.connectionError);
      default:
        CustomLogger.error(error);
        return BaseApiResponse(errorCode: AppErrorCode.unknownError);
    }
  }

  @protected
  BaseApiResponse parseResponse(http.Response response) {
    if (isLoggerOutputEnabled) {
      CustomLogger.httpInterceptor.logResponse(response: response);
    }
    return ApiResponseParser.parseRawResponse(response);
  }
}
