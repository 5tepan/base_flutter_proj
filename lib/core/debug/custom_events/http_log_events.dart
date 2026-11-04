import 'dart:convert';

import 'package:base_flutter_proj/core/debug/custom_events/base_http_log.dart';
import 'package:base_flutter_proj/core/debug/sensitive_log_redaction.dart';
import 'package:curl_converter/curl_converter.dart';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Конкретные логи HTTP-запросов и ответов.
class HttpRequestLog extends BaseHttpLog<RequestOptions> {
  HttpRequestLog(super.message, {required super.data});

  @override
  AnsiPen get pen => AnsiPen()..xterm(219);

  @override
  String get key => TalkerKey.httpRequest;

  @override
  String get titleLog => 'Request';

  @override
  String get method => data.method;

  @override
  int? get statusCode => null;

  @override
  Map<String, String> get headers => stringHeaders(data.headers);

  @override
  String? get curl {
    final requestData = data.data;
    if (requestData is FormData) return null;
    return Curl(
      uri: data.uri,
      method: data.method,
      headers: SensitiveLogRedaction.headers(stringHeaders(data.headers)),
      data: requestData == null
          ? null
          : requestData is String
          ? requestData
          : jsonEncode(requestData),
    ).toCurlString();
  }
}

class HttpResponseLog extends BaseHttpLog<Response<dynamic>> {
  HttpResponseLog(super.message, {required super.data, super.responseBody});

  @override
  AnsiPen get pen => AnsiPen()..xterm(46);

  @override
  String get key => TalkerKey.httpResponse;

  @override
  String get titleLog => 'Response';

  @override
  String? get method => data.requestOptions.method;

  @override
  int? get statusCode => data.statusCode;

  @override
  Map<String, String>? get headers =>
      stringHeaders(data.requestOptions.headers);

  @override
  String? get curl => null;
}

class HttpErrorLog extends BaseHttpLog<Response<dynamic>> {
  HttpErrorLog(super.message, {required super.data, super.responseBody});

  @override
  AnsiPen get pen => AnsiPen()..red();

  @override
  String get key => TalkerKey.httpError;

  @override
  String get titleLog => 'Error';

  @override
  String? get method => data.requestOptions.method;

  @override
  int? get statusCode => data.statusCode;

  @override
  Map<String, String>? get headers =>
      stringHeaders(data.requestOptions.headers);

  @override
  String? get curl => null;
}
