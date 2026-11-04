import 'package:base_flutter_proj/core/config.dart';
import 'package:flutter/foundation.dart';

/// Снимок `--dart-define`. Пустая строка значит «ключ не задан».
@immutable
class EnvDefines {
  const EnvDefines({
    this.flavor = 'dev',
    this.apiUrlDomain = '',
    this.apiUrlRelativePath = '',
    this.apiUseHttps = '',
    this.enableFirebase = '',
    this.showDebugBanner = '',
    this.useFakeApi = '',
    this.enableWebSocket = '',
    this.useMockWebSocket = '',
    this.webSocketHost = '',
    this.webSocketPort = '',
    this.localeMode = '',
    this.mapKitApiKey = '',
  });

  final String flavor;
  final String apiUrlDomain;
  final String apiUrlRelativePath;
  final String apiUseHttps;
  final String enableFirebase;
  final String showDebugBanner;
  final String useFakeApi;
  final String enableWebSocket;
  final String useMockWebSocket;
  final String webSocketHost;
  final String webSocketPort;
  final String localeMode;
  final String mapKitApiKey;

  static EnvDefines fromEnvironment() {
    return const EnvDefines(
      flavor: String.fromEnvironment('FLAVOR', defaultValue: 'dev'),
      apiUrlDomain: String.fromEnvironment('API_URL_DOMAIN'),
      apiUrlRelativePath: String.fromEnvironment('API_URL_RELATIVE_PATH'),
      apiUseHttps: String.fromEnvironment('API_USE_HTTPS'),
      enableFirebase: String.fromEnvironment('ENABLE_FIREBASE'),
      showDebugBanner: String.fromEnvironment('SHOW_DEBUG_BANNER'),
      useFakeApi: String.fromEnvironment('USE_FAKE_API'),
      enableWebSocket: String.fromEnvironment('ENABLE_WEBSOCKET'),
      useMockWebSocket: String.fromEnvironment('USE_MOCK_WEBSOCKET'),
      webSocketHost: String.fromEnvironment('WS_HOST'),
      webSocketPort: String.fromEnvironment('WS_PORT'),
      localeMode: String.fromEnvironment('LOCALE_MODE'),
      mapKitApiKey: String.fromEnvironment('MAPKIT_API_KEY'),
    );
  }
}

/// Читает конфигурацию из `--dart-define` / `--dart-define-from-file`.
abstract final class EnvReader {
  static Config getConfig() => configFrom(EnvDefines.fromEnvironment());

  @visibleForTesting
  static Config configFrom(EnvDefines env) {
    final flavor = switch (env.flavor) {
      'prod' => Flavor.prod,
      'devbackend' => Flavor.devBackend,
      'dev' => Flavor.dev,
      _ => throw Exception('Unknown FLAVOR: ${env.flavor}'),
    };
    final isProd = flavor == Flavor.prod;
    final isDev = flavor == Flavor.dev;

    return Config(
      apiUrlDomain: _orDefault(
        env.apiUrlDomain,
        isProd ? 'api.myapp.com' : 'localhost:8000',
      ),
      apiUrlRelativePath: _orDefault(env.apiUrlRelativePath, '/api/'),
      isHttpsApi: _parseBool(env.apiUseHttps, defaultValue: isProd),
      flavor: flavor,
      showDebugBanner: _parseBool(env.showDebugBanner, defaultValue: !isProd),
      enableFirebase: _parseBool(env.enableFirebase),
      useFakeApi: _parseBool(env.useFakeApi, defaultValue: isDev),
      enableWebSocket: _parseBool(env.enableWebSocket, defaultValue: !isProd),
      useMockWebSocket: _parseBool(env.useMockWebSocket, defaultValue: isDev),
      webSocketHost: _orNull(env.webSocketHost),
      webSocketPort: _parsePort(env.webSocketPort),
      localeMode: _localeMode(
        env.localeMode.isEmpty
            ? (isProd ? 'russianOnly' : 'russianAndEnglish')
            : env.localeMode,
      ),
      mapKitApiKey: env.mapKitApiKey,
    );
  }

  static String _orDefault(String value, String fallback) {
    return value.isEmpty ? fallback : value;
  }

  static String? _orNull(String value) => value.isEmpty ? null : value;

  static int? _parsePort(String value) {
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
