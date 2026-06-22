import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/helpers/string_validator.dart';
import 'package:base_flutter_proj/core/l10n/error_localizer.dart';

abstract class FormValidator {
  static String? validateDateOfBirth(DateTime? value) {
    return validateRequiredField(
      value,
      error: ErrorLocalizer.message(AppErrorCode.dateOfBirthRequired),
    );
  }

  static String? validateName(String? value) {
    return validateRequiredField(
      value,
      error: ErrorLocalizer.message(AppErrorCode.nameRequired),
    );
  }

  static String? validateSurname(String? value) {
    return validateRequiredField(
      value,
      error: ErrorLocalizer.message(AppErrorCode.surnameRequired),
    );
  }

  static String? validateFIOField(String? value) {
    return validateRequiredField(
      value,
      error: ErrorLocalizer.message(AppErrorCode.fioRequired),
    );
  }

  static String? validateCode(String? value, {String? error}) {
    return validateRequiredField(
      value,
      error: error ?? ErrorLocalizer.message(AppErrorCode.codeRequired),
    );
  }

  static String? validateRequiredField<T>(T? value, {String? error}) {
    final message =
        error ?? ErrorLocalizer.message(AppErrorCode.fieldRequired);
    if (value is String) {
      return value.trim().isEmpty ? message : null;
    }
    return value == null ? message : null;
  }

  static String? validatePhone(
    String? value, {
    String? emptyError,
    String? invalidError,
  }) {
    if (value == null || value.isEmpty) {
      return emptyError ??
          ErrorLocalizer.message(AppErrorCode.phoneRequired);
    }
    if (value.length < 18) {
      return invalidError ??
          ErrorLocalizer.message(AppErrorCode.phoneInvalid);
    }
    return null;
  }

  static String? validatePassword(String? value) {
    return ((value?.length ?? 0) < 6)
        ? ErrorLocalizer.message(AppErrorCode.passwordMinLength)
        : null;
  }

  static String? validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return ErrorLocalizer.message(AppErrorCode.emailRequired);
    }
    if (!StringValidator.validateEmail(email: value!)) {
      return ErrorLocalizer.message(AppErrorCode.emailInvalid);
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value, {
    required String original,
  }) {
    final firstValidateRes = validatePassword(value);
    if (firstValidateRes?.isNotEmpty ?? false) {
      return firstValidateRes;
    }
    return value == original
        ? null
        : ErrorLocalizer.message(AppErrorCode.passwordMismatch);
  }
}
