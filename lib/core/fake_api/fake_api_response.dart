import 'dart:convert';

import 'package:http/http.dart' as http;

/// Хелперы для ответов Fake API в формате `{ data, meta }`.
abstract final class FakeApiResponse {
  static http.Response json(
    Uri url, {
    required Object? data,
    bool success = true,
    String? error,
    int statusCode = 200,
  }) {
    final body = jsonEncode({
      'data': data ?? <String, dynamic>{},
      'meta': {
        'success': success,
        if (error != null) 'error': error,
      },
    });
    return http.Response(
      body,
      statusCode,
      headers: {'content-type': 'application/json'},
      request: http.Request('GET', url),
    );
  }

  static http.Response fromEnvelope(
    Uri url,
    Map<String, dynamic> envelope, {
    int statusCode = 200,
  }) {
    return http.Response(
      jsonEncode(envelope),
      statusCode,
      headers: {'content-type': 'application/json'},
      request: http.Request('GET', url),
    );
  }

  static http.Response notFound(Uri url, {String message = 'Not found'}) {
    return json(
      url,
      data: <String, dynamic>{},
      success: false,
      error: message,
    );
  }
}
