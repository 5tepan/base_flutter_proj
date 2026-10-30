import 'dart:convert';

import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  http.Response response(Object? body, int statusCode) {
    final text = body is String ? body : jsonEncode(body);
    return http.Response.bytes(utf8.encode(text), statusCode);
  }

  test('reads a successful envelope', () {
    final parsed = ApiResponseParser.parseRawResponse(
      response({
        'data': {'id': 1},
        'meta': {'success': true},
      }, 200),
    );

    expect(parsed.isError, isFalse);
    expect(parsed.statusCode, 200);
    expect(parsed.dataJson, {'id': 1});
  });

  test('keeps the server message when success is false', () {
    final parsed = ApiResponseParser.parseRawResponse(
      response({
        'data': null,
        'meta': {'success': false, 'error': 'Телефон не найден'},
      }, 200),
    );

    expect(parsed.errorCode, AppErrorCode.requestFailed);
    expect(parsed.serverMessage, 'Телефон не найден');
  });

  test('accepts snake_case invalid access token on HTTP 401', () {
    final parsed = ApiResponseParser.parseRawResponse(
      response({
        'data': null,
        'meta': {
          'success': false,
          'invalid_access_token': true,
          'error': 'expired',
        },
      }, 401),
    );

    expect(parsed.statusCode, 401);
    expect(parsed.meta?.invalidAccessToken, isTrue);
    expect(parsed.serverMessage, 'expired');
    expect(parsed.errorCode, AppErrorCode.requestFailed);
  });

  test('accepts camelCase invalid access token', () {
    final parsed = ApiResponseParser.parseRawResponse(
      response({
        'data': null,
        'meta': {'success': false, 'invalidAccessToken': true},
      }, 401),
    );

    expect(parsed.meta?.invalidAccessToken, isTrue);
  });

  test('marks a non-json 401 without dropping the status', () {
    final parsed = ApiResponseParser.parseRawResponse(response('nope', 401));

    expect(parsed.statusCode, 401);
    expect(parsed.rawData, 'nope');
    expect(parsed.isError, isTrue);
  });

  test('rejects a body without meta', () {
    final parsed = ApiResponseParser.parseRawResponse(
      response({'data': {}}, 200),
    );

    expect(parsed.errorCode, AppErrorCode.missingMeta);
  });

  test('rejects invalid json', () {
    final parsed = ApiResponseParser.parseRawResponse(response('{', 200));

    expect(parsed.errorCode, AppErrorCode.invalidJson);
  });
}
