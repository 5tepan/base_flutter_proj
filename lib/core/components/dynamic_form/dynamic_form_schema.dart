/// Варианты полей для динамических форм (server-driven MVP).
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

  factory DynamicFormSelectOption.fromJson(Map<String, dynamic> json) {
    final value = json['value'];
    final label = json['label'];
    if (value is! String || label is! String) {
      throw FormatException(
        'Select option requires string value and label: $json',
      );
    }
    return DynamicFormSelectOption(value: value, label: label);
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'label': label,
      };
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

  factory DynamicFormFieldSchema.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final label = json['label'];
    final typeRaw = json['type'];
    if (name is! String || label is! String || typeRaw is! String) {
      throw FormatException(
        'Field requires string name, label and type: $json',
      );
    }

    return DynamicFormFieldSchema(
      name: name,
      label: label,
      type: DynamicFormFieldTypeParsing.fromString(typeRaw),
      required: json['required'] == true,
      minLength: _readInt(json['min_length']),
      maxLength: _readInt(json['max_length']),
      pattern: json['pattern'] as String?,
      min: _readInt(json['min']),
      max: _readInt(json['max']),
      options: _readOptions(json['options']),
      minLines: _readInt(json['min_lines']),
      maxLines: _readInt(json['max_lines']),
      obscureText: json['obscure_text'] == true,
      helperText: json['helper_text'] as String?,
      initialValue: json['initial_value'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.name,
        'label': label,
        if (required) 'required': required,
        if (minLength != null) 'min_length': minLength,
        if (maxLength != null) 'max_length': maxLength,
        if (pattern != null) 'pattern': pattern,
        if (min != null) 'min': min,
        if (max != null) 'max': max,
        if (options.isNotEmpty)
          'options': options.map((option) => option.toJson()).toList(),
        if (minLines != null) 'min_lines': minLines,
        if (maxLines != null) 'max_lines': maxLines,
        if (obscureText) 'obscure_text': obscureText,
        if (helperText != null) 'helper_text': helperText,
        if (initialValue != null) 'initial_value': initialValue,
      };

  static int? _readInt(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse('$value');
  }

  static List<DynamicFormSelectOption> _readOptions(Object? value) {
    if (value is! List) {
      return const [];
    }

    return value
        .map(
          (item) => DynamicFormSelectOption.fromJson(
            item as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}

class DynamicFormSchema {
  const DynamicFormSchema({
    required this.version,
    required this.fields,
  });

  final int version;
  final List<DynamicFormFieldSchema> fields;

  factory DynamicFormSchema.fromJson(Map<String, dynamic> json) {
    final version = json['version'];
    final fieldsRaw = json['fields'];
    if (version is! num || fieldsRaw is! List) {
      throw FormatException('Schema requires version and fields: $json');
    }

    return DynamicFormSchema(
      version: version.toInt(),
      fields: fieldsRaw
          .map(
            (field) => DynamicFormFieldSchema.fromJson(
              field as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'fields': fields.map((field) => field.toJson()).toList(),
      };
}

abstract final class DynamicFormFieldTypeParsing {
  static DynamicFormFieldType fromString(String value) {
    return DynamicFormFieldType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw FormatException('Unknown field type: $value'),
    );
  }
}
