import 'package:base_flutter_proj/core/base/base_api/entities/base_api_response.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/generated/l10n.dart';

/// Маппинг [AppErrorCode] → локализованная строка.
abstract final class ErrorLocalizer {
  static String message(
    AppErrorCode code, {
    String? serverMessage,
  }) {
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }

    return switch (code) {
      AppErrorCode.noInternet => S.current.apiNoInternet,
      AppErrorCode.connectionError => S.current.apiConnectionError,
      AppErrorCode.unknownError => S.current.apiUnknownError,
      AppErrorCode.requestFailed => S.current.apiRequestFailed,
      AppErrorCode.dataNotFound => S.current.apiDataNotFound,
      AppErrorCode.parseError => S.current.apiParseError,
      AppErrorCode.missingMeta => S.current.apiMissingMeta,
      AppErrorCode.missingData => S.current.apiMissingData,
      AppErrorCode.invalidMeta => S.current.apiInvalidMeta,
      AppErrorCode.badRequestFormat => S.current.apiBadRequestFormat,
      AppErrorCode.invalidJson => S.current.apiInvalidJson,
      AppErrorCode.phoneRequired => S.current.authPhoneRequired,
      AppErrorCode.invalidConfirmationCode =>
        S.current.authInvalidConfirmationCode,
      AppErrorCode.sessionExpired => S.current.authSessionExpired,
      AppErrorCode.sendCodeFailed => S.current.authSendCodeFailed,
      AppErrorCode.verifyCodeFailed => S.current.authVerifyCodeFailed,
      AppErrorCode.resendCodeFailed => S.current.authResendCodeFailed,
      AppErrorCode.refreshSessionFailed => S.current.authRefreshSessionFailed,
      AppErrorCode.dateOfBirthRequired => S.current.validationDateOfBirth,
      AppErrorCode.nameRequired => S.current.validationName,
      AppErrorCode.surnameRequired => S.current.validationSurname,
      AppErrorCode.fioRequired => S.current.validationFio,
      AppErrorCode.fieldRequired => S.current.validationRequiredField,
      AppErrorCode.phoneInvalid => S.current.phoneInvalid,
      AppErrorCode.codeRequired => S.current.enterCode,
      AppErrorCode.passwordMinLength => S.current.validationPasswordMin,
      AppErrorCode.emailRequired => S.current.validationEmailRequired,
      AppErrorCode.emailInvalid => S.current.validationEmailInvalid,
      AppErrorCode.passwordMismatch => S.current.validationPasswordMismatch,
    };
  }

  static String fromAppException(AppException error) {
    return message(error.code, serverMessage: error.serverMessage);
  }

  static String fromApiResponse(BaseApiResponse response) {
    if (response.errorCode != null) {
      return message(
        response.errorCode!,
        serverMessage: response.serverMessage,
      );
    }
    if (response.serverMessage != null && response.serverMessage!.isNotEmpty) {
      return response.serverMessage!;
    }
    return message(AppErrorCode.unknownError);
  }
}
