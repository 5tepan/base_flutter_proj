import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BaseApiInterceptor extends Interceptor {
  BaseApiInterceptor({required this.packageInfo, this.tokenHolder});

  final PackageInfo packageInfo;
  final AuthTokenHolder? tokenHolder;

  Map<String, String> get headers => {
    'X-Client-Version': '${packageInfo.version}+${packageInfo.buildNumber}',
    'accept': 'application/json',
  };

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(headers);

    final accessToken = tokenHolder?.accessToken;
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }
}
