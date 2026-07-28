import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/model/entities/app_settings.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';

/// Загрузка серверных настроек приложения.
class SettingsApi {
  SettingsApi({
    required PublicApi publicApi,
  }) : _publicApi = publicApi;

  final PublicApi _publicApi;

  static const _settingsPath = 'app/settings';

  Future<AppSettings> load() async {
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
