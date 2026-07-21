/// Варианты полей для динамических форм (server-driven MVP).
///
/// Контракт schema пока не привязан к конкретному формату API,
/// но его можно будет сериализовать/десериализовать позже.
library dynamic_form_schema;

enum DynamicFormFieldType {
  text,
  phone,
  email,
  number,
  textarea,
  select,
  checkbox,
}

class DynamicFormSelectOption {
  const DynamicFormSelectOption({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
}

class DynamicFormFieldSchema {
  const DynamicFormFieldSchema({
    required this.name,
    required this.label,
    required this.type,
    this.required = false,
    this.minLength,
    this.maxLength,
    this.pattern,
    this.min,
    this.max,
    this.options = const [],
    this.minLines,
    this.maxLines,
    this.obscureText = false,
    this.helperText,
    this.initialValue,
  });

  final String name;
  final String label;
  final DynamicFormFieldType type;

  final bool required;
  final int? minLength;
  final int? maxLength;
  final String? pattern;

  /// Диапазон для числовых значений (типы `number`).
  final int? min;
  final int? max;

  /// Опции для типа `select`.
  final List<DynamicFormSelectOption> options;

  /// Для `textarea`.
  final int? minLines;
  final int? maxLines;

  /// Для типа `text` (например password).
  final bool obscureText;

  /// Небольшая подсказка под полем (пока без i18n).
  final String? helperText;

  /// Стартовое значение (используется в демо/локально).
  final dynamic initialValue;
}

class DynamicFormSchema {
  const DynamicFormSchema({
    required this.version,
    required this.fields,
  });

  final int version;
  final List<DynamicFormFieldSchema> fields;
}

