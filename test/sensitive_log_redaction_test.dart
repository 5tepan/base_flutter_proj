import 'package:base_flutter_proj/core/debug/sensitive_log_redaction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hides authorization headers and token query parameters', () {
    final headers = SensitiveLogRedaction.headers({
      'Authorization': 'Bearer secret',
      'Accept': 'application/json',
    });
    final url = SensitiveLogRedaction.url(
      Uri.parse('https://api.example/ws?token=secret&room=1'),
    );

    expect(headers['Authorization'], SensitiveLogRedaction.redacted);
    expect(headers['Accept'], 'application/json');
    expect(
      Uri.parse(url).queryParameters['token'],
      SensitiveLogRedaction.redacted,
    );
    expect(Uri.parse(url).queryParameters['room'], '1');
    expect(url, isNot(contains('secret')));
  });
}
