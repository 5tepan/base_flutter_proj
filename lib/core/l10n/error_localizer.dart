import 'package:base_flutter_proj/core/base/base_api/entities/base_api_response.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/generated/l10n.dart';

/// Маппинг [AppErrorCode] → локализованная строка.
abstract final class ErrorLocalizer {
  static String message(
    AppErrorCode code,
    S l10n, {
    String? serverMessage,
  }) {
    if (serverMessage != null && serverMessage.isNotEmpty) {
      return serverMessage;
    }

    return switch (code) {
      AppErrorCode.noInternet => l10n.apiNoInternet,
      AppErrorCode.connectionError => l10n.apiConnectionError,
      AppErrorCode.unknownError => l10n.apiUnknownError,
      AppErrorCode.requestFailed => l10n.apiRequestFailed,
      AppErrorCode.dataNotFound => l10n.apiDataNotFound,
      AppErrorCode.parseError => l10n.apiParseError,
      AppErrorCode.missingMeta => l10n.apiMissingMeta,
      AppErrorCode.missingData => l10n.apiMissingData,
      AppErrorCode.invalidMeta => l10n.apiInvalidMeta,
      AppErrorCode.badRequestFormat => l10n.apiBadRequestFormat,
      AppErrorCode.invalidJson => l10n.apiInvalidJson,
      AppErrorCode.phoneRequired => l10n.authPhoneRequired,
      AppErrorCode.invalidConfirmationCode => l10n.authInvalidConfirmationCode,
      AppErrorCode.sessionExpired => l10n.authSessionExpired,
      AppErrorCode.sendCodeFailed => l10n.authSendCodeFailed,
      AppErrorCode.verifyCodeFailed => l10n.authVerifyCodeFailed,
      AppErrorCode.resendCodeFailed => l10n.authResendCodeFailed,
      AppErrorCode.refreshSessionFailed => l10n.authRefreshSessionFailed,
      AppErrorCode.dateOfBirthRequired => l10n.validationDateOfBirth,
      AppErrorCode.nameRequired => l10n.validationName,
      AppErrorCode.surnameRequired => l10n.validationSurname,
      AppErrorCode.fioRequired => l10n.validationFio,
      AppErrorCode.fieldRequired => l10n.validationRequiredField,
      AppErrorCode.phoneInvalid => l10n.phoneInvalid,
      AppErrorCode.codeRequired => l10n.enterCode,
      AppErrorCode.passwordMinLength => l10n.validationPasswordMin,
      AppErrorCode.emailRequired => l10n.validationEmailRequired,
      AppErrorCode.emailInvalid => l10n.validationEmailInvalid,
      AppErrorCode.passwordMismatch => l10n.validationPasswordMismatch,
      AppErrorCode.sendMessageFailed => l10n.chatSendMessageFailed,
    };
  }

  static String fromAppException(AppException error, S l10n) {
    return message(error.code, l10n, serverMessage: error.serverMessage);
  }

  static String fromApiResponse(BaseApiResponse response, S l10n) {
    if (response.errorCode != null) {
      return message(
        response.errorCode!,
        l10n,
        serverMessage: response.serverMessage,
      );
    }
    if (response.serverMessage != null && response.serverMessage!.isNotEmpty) {
      return response.serverMessage!;
    }
    return message(AppErrorCode.unknownError, l10n);
  }
}
