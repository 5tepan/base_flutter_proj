import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_response.dart';
import 'package:http/http.dart' as http;

abstract final class FakeAuthHandlers {
  static Future<http.Response?> handle({
    required String method,
    required String path,
    required Uri url,
    String? body,
  }) async {
    if (method != 'POST') {
      return null;
    }

    switch (path) {
      case 'auth/send-code':
        return FakeApiResponse.fromEnvelope(
          url,
          await FakeApiFixtureLoader.loadEnvelope('auth/send-code.post.json'),
        );
      case 'auth/resend-code':
        return FakeApiResponse.fromEnvelope(
          url,
          await FakeApiFixtureLoader.loadEnvelope('auth/resend-code.post.json'),
        );
      case 'auth/verify-code':
        return _verifyCode(url: url, body: body);
      case 'auth/refresh':
        return _refresh(url: url, body: body);
      default:
        return null;
    }
  }

  static Future<http.Response> _verifyCode({
    required Uri url,
    String? body,
  }) async {
    final payload = _decodeBody(body);
    final code = '${payload['code'] ?? ''}';
    final phone = '${payload['phone'] ?? ''}';

    if (code != FakeApiConstants.verificationCode) {
      return FakeApiResponse.fromEnvelope(
        url,
        await FakeApiFixtureLoader.loadEnvelope(
          'auth/verify-code.error.post.json',
        ),
      );
    }

    final success = await FakeApiFixtureLoader.loadEnvelope(
      'auth/verify-code.success.post.json',
    );
    final data = Map<String, dynamic>.from(success['data'] as Map);
    final session = Map<String, dynamic>.from(data['session'] as Map);
    session['phone_number'] = phone;
    session['access_token'] = 'mock_access_$phone';
    session['refresh_token'] = 'mock_refresh_$phone';
    data['session'] = session;
    return FakeApiResponse.json(url, data: data);
  }

  static Future<http.Response> _refresh({
    required Uri url,
    String? body,
  }) async {
    final payload = _decodeBody(body);
    final refreshToken = '${payload['refresh_token'] ?? ''}';

    if (!refreshToken.startsWith('mock_refresh_')) {
      return FakeApiResponse.json(
        url,
        data: <String, dynamic>{},
        success: false,
        error: 'Session expired',
      );
    }

    final phone = refreshToken.replaceFirst('mock_refresh_', '');
    final success = await FakeApiFixtureLoader.loadEnvelope(
      'auth/refresh.post.json',
    );
    final data = Map<String, dynamic>.from(success['data'] as Map);
    final session = Map<String, dynamic>.from(data['session'] as Map);
    session['phone_number'] = phone;
    session['access_token'] = 'mock_access_refreshed_$phone';
    session['refresh_token'] = 'mock_refresh_$phone';
    data['session'] = session;
    return FakeApiResponse.json(url, data: data);
  }

  static Map<String, dynamic> _decodeBody(String? body) {
    if (body == null || body.isEmpty) {
      return {};
    }
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return {};
  }
}
