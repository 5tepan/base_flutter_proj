import 'package:base_flutter_proj/core/debug/custom_events/http_log_events.dart';
import 'package:base_flutter_proj/core/debug/sensitive_log_redaction.dart';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';

class HTTPLogInterceptor extends Interceptor {
  HTTPLogInterceptor({Talker? talker}) : _talker = talker ?? Talker();

  final Talker _talker;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final message = SensitiveLogRedaction.url(options.uri);
    _talker.logCustom(HttpRequestLog(message, data: options));
    handler.next(options);
  }

  void logResponse({required Response<dynamic> response}) {
    final request = response.requestOptions;
    final message = SensitiveLogRedaction.url(request.uri);

    if ((response.statusCode ?? 0) >= 400) {
      _talker.logCustom(HttpErrorLog(message, data: response));
    } else {
      _talker.logCustom(HttpResponseLog(message, data: response));
    }
  }
}
