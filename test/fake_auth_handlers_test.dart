import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/handlers/auth_handlers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<Map<String, dynamic>> verify(String code) async {
    final response = await FakeAuthHandlers.handle(
      method: 'POST',
      path: 'auth/verify-code',
      url: Uri.parse('http://localhost/api/auth/verify-code'),
      body: jsonEncode({'phone': '+79990000000', 'code': code}),
    );
    expect(response, isNotNull);
    return jsonDecode(response!.body) as Map<String, dynamic>;
  }

  test('accepts the demo code 1234', () async {
    final body = await verify('1234');
    final meta = body['meta'] as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final session = data['session'] as Map<String, dynamic>;

    expect(meta['success'], isTrue);
    expect(session['phone_number'], '+79990000000');
    expect(session['access_token'], 'mock_access_+79990000000');
  });

  test('rejects any other code', () async {
    final body = await verify('0000');
    final meta = body['meta'] as Map<String, dynamic>;

    expect(meta['success'], isFalse);
  });
}
