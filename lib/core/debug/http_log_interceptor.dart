import 'dart:async';

import 'package:base_flutter_proj/core/debug/custom_events/http_log_events.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:talker_flutter/talker_flutter.dart';

class HTTPLogInterceptor extends InterceptorContract {
  HTTPLogInterceptor({Talker? talker}) {
    _talker = talker ?? Talker();
  }

  late final Talker _talker;

  /// [HTTPLogInterceptor] settings and customization

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final message = '${request.url}';
    _talker.logCustom(HttpRequestLog(message, data: request));
    return request;
  }

  @override
  FutureOr<BaseResponse> interceptResponse({required BaseResponse response}) {
    return response;
  }

  Future<BaseResponse> logResponse({required BaseResponse response}) async {
    final message = '${response.request?.url}';

    if (response.statusCode >= 400 && response.statusCode < 600) {
      _talker.logCustom(HttpErrorLog(message, data: response));
    } else {
      _talker.logCustom(HttpResponseLog(message, data: response));
    }

    return response;
  }
}
