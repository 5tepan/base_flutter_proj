import 'package:flutter/material.dart';

enum Flavor { dev, devBackend, prod }

/// Режим локализации приложения.
enum AppLocaleMode {
  /// Только русский язык, независимо от языка системы.
  russianOnly,

  /// Русский и английский; выбор по языку системы.
  russianAndEnglish,
}

/// Класс-конфиг приложения.
/// Предполагается, что у тестовых сборок приложения и релизных сборок приложения будет свой конфиг:
/// - со своим адресом сервера
/// - со своими остальными настройками
class Config {
  final String apiUrlDomain;
  final String apiUrlRelativePath;
  final bool isHttpsApi;
  final double? imagePickerMaxImageSize;
  final int? imagePickerImageQuality;

  final bool showDebugBanner;
  final bool enableFirebase;
  final bool useMockAuthApi;
  final bool useMockShopApi;
  final bool useMockAppSettingsApi;
  final bool useMockChatApi;
  final bool useMockDynamicFormApi;
  final bool enableWebSocket;
  final bool useMockWebSocket;
  final String? webSocketAppKey;
  final String? webSocketHost;
  final int? webSocketPort;
  final String webSocketAuthRelativePath;
  final AppLocaleMode localeMode;
  final Flavor flavor;

  const Config({
    required this.apiUrlDomain,
    required this.apiUrlRelativePath,
    this.isHttpsApi = false,
    this.flavor = Flavor.dev,
    this.imagePickerMaxImageSize = 1536.0,
    this.imagePickerImageQuality = 95,
    this.showDebugBanner = true,
    this.enableFirebase = false,
    this.useMockAuthApi = true,
    this.useMockShopApi = true,
    this.useMockAppSettingsApi = true,
    this.useMockChatApi = true,
    this.useMockDynamicFormApi = true,
    this.enableWebSocket = true,
    this.useMockWebSocket = true,
    this.webSocketAppKey,
    this.webSocketHost,
    this.webSocketPort,
    this.webSocketAuthRelativePath = '/api/broadcasting/auth',
    this.localeMode = AppLocaleMode.russianAndEnglish,
  });

  /// Локали, доступные в приложении.
  List<Locale> get supportedLocales => switch (localeMode) {
        AppLocaleMode.russianOnly => const [Locale('ru')],
        AppLocaleMode.russianAndEnglish => const [
            Locale('ru'),
            Locale('en'),
          ],
      };

  /// Принудительная локаль. `null` — выбор по языку системы.
  Locale? get forcedLocale => switch (localeMode) {
        AppLocaleMode.russianOnly => const Locale('ru'),
        AppLocaleMode.russianAndEnglish => null,
      };
}
