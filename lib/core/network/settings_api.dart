import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/model/entities/app_settings.dart';
import 'package:base_flutter_proj/core/model/entities/info_page_holder.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';

/// Загрузка серверных настроек приложения.
class SettingsApi {
  SettingsApi({
    required PublicApi publicApi,
    required bool useMock,
  })  : _publicApi = publicApi,
        _useMock = useMock;

  final PublicApi _publicApi;
  final bool _useMock;

  static const _settingsPath = 'app/settings';

  static const AppSettings mock = AppSettings(
    codeLength: 4,
    pages: InfoPageHolder(
      privacyPolicy: 'https://example.com/privacy-policy',
      termsOfUse: 'https://example.com/terms-of-use',
    ),
    appStoreUrl: 'https://apps.apple.com/app/example',
    googlePlayUrl: 'https://play.google.com/store/apps/details?id=example',
  );

  Future<AppSettings> load() async {
    if (_useMock) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      return mock;
    }

    final response = await _publicApi.sendGetRequest(_settingsPath);

    final parsed = ApiResponseParser.parseObjectFromResponse<AppSettings>(
      response,
      key: 'settings',
      fromJson: AppSettings.fromApiJson,
      emptyErrorCode: AppErrorCode.dataNotFound,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? AppErrorCode.requestFailed,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }
}
