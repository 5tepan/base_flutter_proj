import 'package:http_interceptor/http_interceptor.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BaseApiInterceptor extends InterceptorContract {
  final PackageInfo packageInfo;

  BaseApiInterceptor({required this.packageInfo});

  Map<String, String> get headers => {
    'X-Client-Version': '${packageInfo.version}+${packageInfo.buildNumber}',
    'accept': 'application/json',
  };

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    final requestHeaders = Map<String, String>.from(request.headers);
    requestHeaders.addAll(headers);
    return request.copyWith(headers: requestHeaders);
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async => response;
}
