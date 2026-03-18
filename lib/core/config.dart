enum AppNavigationMode {
  side,
  bottom;

  bool get isSide => this == side;

  bool get isBottom => this == bottom;
}

enum Flavor { dev, prod }

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
  final String appMetricaApiKey;

  final bool showDebugBanner;
  final AppNavigationMode defaultNavigationMode;
  final Flavor flavor;

  final String? livekitUrl;

  const Config({
    required this.apiUrlDomain,
    required this.apiUrlRelativePath,
    required this.appMetricaApiKey,
    this.isHttpsApi = false,
    this.flavor = Flavor.dev,
    this.livekitUrl,
    this.imagePickerMaxImageSize = 1536.0,
    this.imagePickerImageQuality = 95,
    this.showDebugBanner = true,
    this.defaultNavigationMode = AppNavigationMode.bottom,
  });
}
