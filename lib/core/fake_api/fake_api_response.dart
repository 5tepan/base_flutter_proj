import 'dart:convert';

import 'package:dio/dio.dart';

/// Хелперы для ответов Fake API в формате `{ data, meta }`.
abstract final class FakeApiResponse {
  static Response<String> json(
    Uri url, {
    required Object? data,
    bool success = true,
    String? error,
    int statusCode = 200,
  }) {
    final body = jsonEncode({
      'data': data ?? <String, dynamic>{},
      'meta': {'success': success, if (error != null) 'error': error},
    });
    return _response(url, body, statusCode);
  }

  static Response<String> fromEnvelope(
    Uri url,
    Map<String, dynamic> envelope, {
    int statusCode = 200,
  }) {
    return _response(url, jsonEncode(envelope), statusCode);
  }

  static Response<String> notFound(Uri url, {String message = 'Not found'}) {
    return json(url, data: <String, dynamic>{}, success: false, error: message);
  }

  static Response<String> _response(Uri url, String body, int statusCode) {
    return Response<String>(
      requestOptions: RequestOptions(path: url.toString()),
      data: body,
      statusCode: statusCode,
    );
  }
}
