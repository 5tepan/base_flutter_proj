import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/env_reader.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prod defaults to HTTPS and disables fake API', () {
    final config = EnvReader.configFrom(const EnvDefines(flavor: 'prod'));

    expect(config.flavor, Flavor.prod);
    expect(config.isHttpsApi, isTrue);
    expect(config.useFakeApi, isFalse);
    expect(config.useMockWebSocket, isFalse);
    expect(config.showDebugBanner, isFalse);
    expect(config.localeMode, AppLocaleMode.russianOnly);
    expect(config.apiUrlDomain, 'api.myapp.com');
  });

  test('dev keeps the local fake API defaults', () {
    final config = EnvReader.configFrom(const EnvDefines(flavor: 'dev'));

    expect(config.flavor, Flavor.dev);
    expect(config.isHttpsApi, isFalse);
    expect(config.useFakeApi, isTrue);
    expect(config.useMockWebSocket, isTrue);
    expect(config.enableWebSocket, isTrue);
    expect(config.localeMode, AppLocaleMode.russianAndEnglish);
  });

  test('devbackend talks to a real API without the mock socket', () {
    final config = EnvReader.configFrom(const EnvDefines(flavor: 'devbackend'));

    expect(config.flavor, Flavor.devBackend);
    expect(config.useFakeApi, isFalse);
    expect(config.useMockWebSocket, isFalse);
    expect(config.isHttpsApi, isFalse);
  });

  test('explicit defines override flavor defaults', () {
    final config = EnvReader.configFrom(
      const EnvDefines(
        flavor: 'prod',
        apiUseHttps: 'false',
        useFakeApi: 'TRUE',
        showDebugBanner: 'true',
      ),
    );

    expect(config.isHttpsApi, isFalse);
    expect(config.useFakeApi, isTrue);
    expect(config.showDebugBanner, isTrue);
  });

  test('unknown flavor fails loudly', () {
    expect(
      () => EnvReader.configFrom(const EnvDefines(flavor: 'stage')),
      throwsA(isA<Exception>()),
    );
  });
}
