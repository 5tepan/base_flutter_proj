import 'dart:async';
import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_router.dart';
import 'package:http/http.dart' as http;

/// HTTP-клиент, эмулирующий бэкенд по JSON из `assets/fake_api/`.
class FakeApiClient extends http.BaseClient {
  FakeApiClient({
    required String apiRelativePath,
    this.latency = FakeApiConstants.latency,
  }) : _router = FakeApiRouter(apiRelativePath: apiRelativePath);

  final FakeApiRouter _router;
  final Duration latency;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    await Future<void>.delayed(latency);
    final response = await _router.handle(request);
    final bodyBytes = utf8.encode(response.body);
    return http.StreamedResponse(
      Stream<List<int>>.value(bodyBytes),
      response.statusCode,
      contentLength: bodyBytes.length,
      request: request,
      headers: {
        'content-type': 'application/json; charset=utf-8',
        ...response.headers,
      },
      reasonPhrase: response.reasonPhrase,
    );
  }
}
