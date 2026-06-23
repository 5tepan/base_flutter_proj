import 'package:base_flutter_proj/core/config.dart';

/// Читает конфигурацию из `--dart-define` / `--dart-define-from-file`.
abstract final class EnvReader {
  static Config getConfig() {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

    return switch (flavorName) {
      'prod' => _prodConfig(),
      'dev' => _devConfig(),
      _ => throw Exception('Unknown FLAVOR: $flavorName'),
    };
  }

  static Config _devConfig() {
    return Config(
      apiUrlDomain: const String.fromEnvironment(
        'API_URL_DOMAIN',
        defaultValue: 'localhost',
      ),
      apiUrlRelativePath: const String.fromEnvironment(
        'API_URL_RELATIVE_PATH',
        defaultValue: '/api/',
      ),
      isHttpsApi: _apiUseHttps,
      appMetricaApiKey: const String.fromEnvironment('APP_METRICA_API_KEY'),
      flavor: Flavor.dev,
      showDebugBanner: _showDebugBanner(defaultValue: true),
      enableFirebase: _enableFirebase,
      useMockAuthApi: _useMockAuthApi(defaultValue: true),
      localeMode: _localeMode(
        const String.fromEnvironment(
          'LOCALE_MODE',
          defaultValue: 'russianAndEnglish',
        ),
      ),
      livekitUrl: _livekitUrl,
    );
  }

  static Config _prodConfig() {
    return Config(
      apiUrlDomain: const String.fromEnvironment(
        'API_URL_DOMAIN',
        defaultValue: 'api.myapp.com',
      ),
      apiUrlRelativePath: const String.fromEnvironment(
        'API_URL_RELATIVE_PATH',
        defaultValue: '/api/',
      ),
      isHttpsApi: _apiUseHttps,
      appMetricaApiKey: const String.fromEnvironment('APP_METRICA_API_KEY'),
      flavor: Flavor.prod,
      showDebugBanner: _showDebugBanner(),
      enableFirebase: _enableFirebase,
      useMockAuthApi: _useMockAuthApi(),
      localeMode: _localeMode(
        const String.fromEnvironment(
          'LOCALE_MODE',
          defaultValue: 'russianOnly',
        ),
      ),
      livekitUrl: _livekitUrl,
    );
  }

  static bool get _apiUseHttps => _parseBool(
        const String.fromEnvironment('API_USE_HTTPS'),
      );

  static bool get _enableFirebase => _parseBool(
        const String.fromEnvironment('ENABLE_FIREBASE'),
      );

  static bool _showDebugBanner({bool defaultValue = false}) => _parseBool(
        const String.fromEnvironment('SHOW_DEBUG_BANNER'),
        defaultValue: defaultValue,
      );

  static bool _useMockAuthApi({bool defaultValue = false}) => _parseBool(
        const String.fromEnvironment('USE_MOCK_AUTH_API'),
        defaultValue: defaultValue,
      );

  static String? get _livekitUrl {
    const value = String.fromEnvironment('LIVEKIT_URL');
    return value.isEmpty ? null : value;
  }

  static bool _parseBool(String value, {bool defaultValue = false}) {
    if (value.isEmpty) {
      return defaultValue;
    }
    return value.toLowerCase() == 'true';
  }

  static AppLocaleMode _localeMode(String value) {
    return switch (value) {
      'russianOnly' => AppLocaleMode.russianOnly,
      _ => AppLocaleMode.russianAndEnglish,
    };
  }
}
