import 'package:base_flutter_proj/core/debug/custom_events/base_http_log.dart';
import 'package:curl_converter/curl_converter.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Конкретные логи
class HttpRequestLog extends BaseHttpLog<BaseRequest> {
  HttpRequestLog(super.message, {required super.data});

  @override
  AnsiPen get pen => (AnsiPen()..xterm(219));

  @override
  String get key => TalkerKey.httpRequest;

  @override
  String get titleLog => 'Request';

  @override
  String get method => data.method;

  @override
  int? get statusCode => null;

  @override
  Map<String, String> get headers => data.headers;

  @override
  String? get curl {
    if (data is! Request) return null;
    final req = data as Request;
    return Curl(
      uri: req.url,
      method: req.method,
      headers: req.headers,
      data: req.body,
    ).toCurlString();
  }
}

class HttpResponseLog extends BaseHttpLog<BaseResponse> {
  HttpResponseLog(super.message, {required super.data, super.responseBody});

  @override
  AnsiPen get pen => (AnsiPen()..xterm(46));

  @override
  String get key => TalkerKey.httpResponse;

  @override
  String get titleLog => 'Response';

  @override
  String? get method => data.request?.method;

  @override
  int get statusCode => data.statusCode;

  @override
  Map<String, String>? get headers => data.request?.headers;

  @override
  String? get curl => null;
}

class HttpErrorLog extends BaseHttpLog<BaseResponse> {
  HttpErrorLog(super.message, {required super.data, super.responseBody});

  @override
  AnsiPen get pen => AnsiPen()..red();

  @override
  String get key => TalkerKey.httpError;

  @override
  String get titleLog => 'Error';

  @override
  String? get method => data.request?.method;

  @override
  int get statusCode => data.statusCode;

  @override
  Map<String, String>? get headers => data.request?.headers;

  @override
  String? get curl => null;
}
