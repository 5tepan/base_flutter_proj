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
      flavor: Flavor.dev,
      showDebugBanner: _showDebugBanner(defaultValue: true),
      enableFirebase: _enableFirebase,
      useMockAuthApi: _useMockAuthApi(defaultValue: true),
      useMockShopApi: _useMockShopApi(defaultValue: true),
      useMockAppSettingsApi: _useMockAppSettingsApi(defaultValue: true),
      enableWebSocket: _enableWebSocket(defaultValue: true),
      useMockWebSocket: _useMockWebSocket(defaultValue: true),
      webSocketAppKey: _webSocketAppKey,
      webSocketHost: _webSocketHost,
      webSocketPort: _webSocketPort,
      localeMode: _localeMode(
        const String.fromEnvironment(
          'LOCALE_MODE',
          defaultValue: 'russianAndEnglish',
        ),
      ),
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
      flavor: Flavor.prod,
      showDebugBanner: _showDebugBanner(),
      enableFirebase: _enableFirebase,
      useMockAuthApi: _useMockAuthApi(),
      useMockShopApi: _useMockShopApi(),
      useMockAppSettingsApi: _useMockAppSettingsApi(),
      enableWebSocket: _enableWebSocket(),
      useMockWebSocket: _useMockWebSocket(),
      webSocketAppKey: _webSocketAppKey,
      webSocketHost: _webSocketHost,
      webSocketPort: _webSocketPort,
      localeMode: _localeMode(
        const String.fromEnvironment(
          'LOCALE_MODE',
          defaultValue: 'russianOnly',
        ),
      ),
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

  static bool _useMockShopApi({bool defaultValue = false}) => _parseBool(
        const String.fromEnvironment('USE_MOCK_SHOP_API'),
        defaultValue: defaultValue,
      );

  static bool _useMockAppSettingsApi({bool defaultValue = false}) => _parseBool(
        const String.fromEnvironment('USE_MOCK_APP_SETTINGS_API'),
        defaultValue: defaultValue,
      );

  static bool _enableWebSocket({bool defaultValue = false}) => _parseBool(
        const String.fromEnvironment('ENABLE_WEBSOCKET'),
        defaultValue: defaultValue,
      );

  static bool _useMockWebSocket({bool defaultValue = false}) => _parseBool(
        const String.fromEnvironment('USE_MOCK_WEBSOCKET'),
        defaultValue: defaultValue,
      );

  static String? get _webSocketAppKey {
    const value = String.fromEnvironment('WS_APP_KEY');
    return value.isEmpty ? null : value;
  }

  static String? get _webSocketHost {
    const value = String.fromEnvironment('WS_HOST');
    return value.isEmpty ? null : value;
  }

  static int? get _webSocketPort {
    const value = String.fromEnvironment('WS_PORT');
    if (value.isEmpty) {
      return null;
    }
    return int.tryParse(value);
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
