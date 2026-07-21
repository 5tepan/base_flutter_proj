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

  static String? validateMinLength(
    String? value, {
    required int minLength,
    String? error,
  }) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    if (trimmed.length < minLength) {
      return error ?? 'Минимум $minLength символа';
    }
    return null;
  }

  static String? validateMaxLength(
    String? value, {
    required int maxLength,
    String? error,
  }) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    if (trimmed.length > maxLength) {
      return error ?? 'Максимум $maxLength символов';
    }
    return null;
  }

  static String? validatePattern(
    String? value, {
    required Pattern pattern,
    String? error,
  }) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    final regex = pattern is RegExp ? pattern : RegExp(pattern.toString());
    if (!regex.hasMatch(trimmed)) {
      return error ?? 'Некорректный формат';
    }
    return null;
  }

  static String? validateInteger(
    String? value, {
    String? requiredError,
    String? invalidError,
  }) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return requiredError;
    }
    return int.tryParse(trimmed) == null
        ? (invalidError ?? 'Введите число')
        : null;
  }

  static String? validateIntegerRange(
    int? value, {
    int? min,
    int? max,
    String? minError,
    String? maxError,
  }) {
    if (value == null) {
      return null;
    }
    if (min != null && value < min) {
      return minError ?? 'Минимальное значение: $min';
    }
    if (max != null && value > max) {
      return maxError ?? 'Максимальное значение: $max';
    }
    return null;
  }

  static String? validateRequiredTrue(
    bool? value, {
    required S l10n,
    String? error,
  }) {
    if (value == true) {
      return null;
    }
    return error ?? ErrorLocalizer.message(AppErrorCode.fieldRequired, l10n);
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
