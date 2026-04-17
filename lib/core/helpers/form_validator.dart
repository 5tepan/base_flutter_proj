import 'package:base_flutter_proj/core/helpers/string_validator.dart';

abstract class FormValidator {
  static String? validateDateOfBirth(DateTime? value) {
    return validateRequiredField(value, error: 'Выберите дату рождения');
  }

  static String? validateName(String? value) {
    return validateRequiredField(value, error: 'Введите имя');
  }

  static String? validateSurname(String? value) {
    return validateRequiredField(value, error: 'Введите фамилию');
  }

  static String? validateFIOField(String? value) {
    return validateRequiredField(value, error: "Введите ФИО");
  }

  static String? validateCode(String? value) {
    return validateRequiredField(value, error: 'Введите код');
  }

  static String? validateRequiredField<T>(T? value, {String? error}) {
    error ??= 'Неверно заполнено поле';
    if (value is String) {
      return value.trim().isEmpty ? error : null;
    }
    return value == null ? error : null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Введите номер телефона';
    }
    if (value.length < 18) {
      return 'Введите корректный номер телефона';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    return ((value?.length ?? 0) < 6) ? "не менее 6 символов" : null;
  }

  static String? validateEmail(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Введите e-mail';
    }
    if (!StringValidator.validateEmail(email: value!)) {
      return 'Некорректный e-mail';
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
    return value == original ? null : 'пароль должен совпадать';
  }
}
