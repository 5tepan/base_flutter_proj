import 'package:base_flutter_proj/core/base/base_api/base_api_response.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';

/// Объект для возврата результата выполнения запроса к API.
class ApiResponse<T> extends BaseApiResponse {
  T? result;

  ApiResponse({required BaseApiResponse baseApiResponse, this.result})
    : super(
        meta: baseApiResponse.meta,
        rawData: baseApiResponse.rawData,
        errorCode: baseApiResponse.errorCode,
        serverMessage: baseApiResponse.serverMessage,
        dataJson: baseApiResponse.dataJson,
      ) {
    logError();
  }

  ApiResponse.error({
    required AppErrorCode errorCode,
    String? serverMessage,
    required BaseApiResponse baseApiResponse,
  }) : super(
         meta: baseApiResponse.meta,
         rawData: baseApiResponse.rawData,
         errorCode: errorCode,
         serverMessage: serverMessage,
         dataJson: baseApiResponse.dataJson,
       ) {
    logError();
  }

  void logError() {
    if (rawData != null) {
    } else {
      CustomLogger.warning('No server response');
    }
    if (isError) {
      CustomLogger.error(
        'Error: ${errorCode ?? serverMessage ?? ''}',
      );
    }
  }
}
