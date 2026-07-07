import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/helpers/string_validator.dart';
import 'package:base_flutter_proj/core/l10n/error_localizer.dart';
import 'package:base_flutter_proj/generated/l10n.dart';

abstract class FormValidator {
  static String? validateDateOfBirth(DateTime? value, {required S l10n}) {
    return validateRequiredField(
      value,
      l10n: l10n,
      error: ErrorLocalizer.message(AppErrorCode.dateOfBirthRequired, l10n),
    );
  }

  static String? validateName(String? value, {required S l10n}) {
    return validateRequiredField(
      value,
      l10n: l10n,
      error: ErrorLocalizer.message(AppErrorCode.nameRequired, l10n),
    );
  }

  static String? validateSurname(String? value, {required S l10n}) {
    return validateRequiredField(
      value,
      l10n: l10n,
      error: ErrorLocalizer.message(AppErrorCode.surnameRequired, l10n),
    );
  }

  static String? validateFIOField(String? value, {required S l10n}) {
    return validateRequiredField(
      value,
      l10n: l10n,
      error: ErrorLocalizer.message(AppErrorCode.fioRequired, l10n),
    );
  }

  static String? validateCode(
    String? value, {
    required S l10n,
    String? error,
    int codeLength = 4,
  }) {
    final requiredError = validateRequiredField(
      value,
      l10n: l10n,
      error: error ?? ErrorLocalizer.message(AppErrorCode.codeRequired, l10n),
    );
    if (requiredError != null) {
      return requiredError;
    }

    if (value!.length != codeLength) {
      return ErrorLocalizer.message(AppErrorCode.invalidConfirmationCode, l10n);
    }

    return null;
  }

  static String? validateRequiredField<T>(
    T? value, {
    required S l10n,
    String? error,
  }) {
    final message =
        error ?? ErrorLocalizer.message(AppErrorCode.fieldRequired, l10n);
    if (value is String) {
      return value.trim().isEmpty ? message : null;
    }
    return value == null ? message : null;
  }

  static String? validatePhone(
    String? value, {
    required S l10n,
    String? emptyError,
    String? invalidError,
  }) {
    if (value == null || value.isEmpty) {
      return emptyError ??
          ErrorLocalizer.message(AppErrorCode.phoneRequired, l10n);
    }
    if (value.length < 18) {
      return invalidError ??
          ErrorLocalizer.message(AppErrorCode.phoneInvalid, l10n);
    }
    return null;
  }

  static String? validatePassword(String? value, {required S l10n}) {
    return ((value?.length ?? 0) < 6)
        ? ErrorLocalizer.message(AppErrorCode.passwordMinLength, l10n)
        : null;
  }

  static String? validateEmail(String? value, {required S l10n}) {
    if (value?.trim().isEmpty ?? true) {
      return ErrorLocalizer.message(AppErrorCode.emailRequired, l10n);
    }
    if (!StringValidator.validateEmail(email: value!)) {
      return ErrorLocalizer.message(AppErrorCode.emailInvalid, l10n);
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value, {
    required S l10n,
    required String original,
  }) {
    final firstValidateRes = validatePassword(value, l10n: l10n);
    if (firstValidateRes?.isNotEmpty ?? false) {
      return firstValidateRes;
    }
    return value == original
        ? null
        : ErrorLocalizer.message(AppErrorCode.passwordMismatch, l10n);
  }
}
