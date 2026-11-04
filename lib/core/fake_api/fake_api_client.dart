import 'dart:async';

import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_router.dart';
import 'package:dio/dio.dart';

/// Dio interceptor that serves JSON fixtures instead of sending requests.
class FakeApiInterceptor extends Interceptor {
  FakeApiInterceptor({
    required String apiRelativePath,
    this.latency = FakeApiConstants.latency,
  }) : _router = FakeApiRouter(apiRelativePath: apiRelativePath);

  final FakeApiRouter _router;
  final Duration latency;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(latency);
    try {
      final response = await _router.handle(options);
      handler.resolve(response, true);
    } catch (error, stackTrace) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: error,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
