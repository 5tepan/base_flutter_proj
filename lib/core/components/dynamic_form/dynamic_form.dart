import 'package:base_flutter_proj/core/components/custom_check_box.dart';
import 'package:base_flutter_proj/core/components/decorated_dropdown_form_field.dart';
import 'package:base_flutter_proj/core/components/decorated_text_form_field.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_controller.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/core/helpers/form_validator.dart';
import 'package:base_flutter_proj/core/helpers/phone_input_helper.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Динамическая форма поверх стандартного `Form`/`FormField`.
///
/// Ключевой момент: валидация/submit делаются через общий `AppForm`,
/// поэтому здесь мы используем обычные `validator`/`onSaved` у `FormField`.
class DynamicForm extends StatelessWidget {
  const DynamicForm({
    required this.schema,
    required this.controller,
    this.enabled = true,
    super.key,
  });

  final DynamicFormSchema schema;
  final DynamicFormController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...schema.fields.map((field) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildField(context, field),
          );
        }),
      ],
    );
  }

  Widget _buildField(BuildContext context, DynamicFormFieldSchema field) {
    final l10n = S.of(context);

    switch (field.type) {
      case DynamicFormFieldType.text:
        return DecoratedTextFormField(
          labelText: field.label,
          obscureText: field.obscureText,
          initialValue: _initialTextValue(field),
          enabled: enabled,
          decoration: InputDecoration(helperText: field.helperText),
          maxLength: field.maxLength,
          minLines: 1,
          maxLines: 1,
          keyboardType: TextInputType.text,
          validator: (value) => _validateText(value, field, l10n),
          onChanged: (value) => controller.setValue(field.name, value ?? ''),
          onSaved: (value) => controller.setValue(field.name, value ?? ''),
        );
      case DynamicFormFieldType.phone:
        return DecoratedTextFormField(
          labelText: field.label,
          initialValue: _initialTextValue(field),
          enabled: enabled,
          decoration: InputDecoration(helperText: field.helperText),
          keyboardType: TextInputType.phone,
          maxLength: field.maxLength,
          inputFormatters: PhoneInputHelper.defaultPhoneInputFormatter,
          validator: (value) => _validatePhone(value, field, l10n),
          onChanged: (value) => controller.setValue(field.name, value ?? ''),
          onSaved: (value) => controller.setValue(field.name, value ?? ''),
        );
      case DynamicFormFieldType.email:
        return DecoratedTextFormField(
          labelText: field.label,
          initialValue: _initialTextValue(field),
          enabled: enabled,
          decoration: InputDecoration(helperText: field.helperText),
          keyboardType: TextInputType.emailAddress,
          maxLength: field.maxLength,
          validator: (value) => _validateEmail(value, field, l10n),
          onChanged: (value) => controller.setValue(field.name, value ?? ''),
          onSaved: (value) => controller.setValue(field.name, value ?? ''),
        );
      case DynamicFormFieldType.number:
        return DecoratedTextFormField(
          labelText: field.label,
          initialValue: _initialTextValue(field),
          enabled: enabled,
          decoration: InputDecoration(helperText: field.helperText),
          keyboardType: TextInputType.number,
          validator: (value) => _validateNumber(value, field, l10n),
          onChanged: (value) {
            final parsed = _tryParseInt(value);
            controller.setValue(field.name, parsed ?? value ?? '');
          },
          onSaved: (value) {
            final parsed = _tryParseInt(value);
            if (parsed != null) {
              controller.setValue(field.name, parsed);
            } else {
              controller.setValue(field.name, value ?? '');
            }
          },
        );
      case DynamicFormFieldType.textarea:
        final minLines = field.minLines ?? 3;
        final maxLines = field.maxLines ?? 6;
        return DecoratedTextFormField(
          labelText: field.label,
          initialValue: _initialTextValue(field),
          enabled: enabled,
          decoration: InputDecoration(helperText: field.helperText),
          keyboardType: TextInputType.multiline,
          maxLength: field.maxLength,
          minLines: minLines,
          maxLines: maxLines,
          validator: (value) => _validateText(value, field, l10n),
          onChanged: (value) => controller.setValue(field.name, value ?? ''),
          onSaved: (value) => controller.setValue(field.name, value ?? ''),
        );
      case DynamicFormFieldType.select:
        return DecoratedDropdownFormField<String>(
          initialValue: _initialSelectValue(field),
          labelText: field.label,
          hintText: field.helperText,
          decoration: const InputDecoration(),
          items: field.options
              .map(
                (o) => DecoratedDropdownItem<String>(
                  value: o.value,
                  label: o.label,
                ),
              )
              .toList(),
          onChanged: (value) => controller.setValue(field.name, value),
          validator: (value) => _validateSelect(value, field, l10n),
          onSaved: (value) => controller.setValue(field.name, value),
        );
      case DynamicFormFieldType.checkbox:
        return FormField<bool>(
          initialValue: _initialBoolValue(field),
          enabled: enabled,
          validator: (value) => _validateCheckbox(value, field, l10n),
          onSaved: (value) => controller.setValue(field.name, value ?? false),
          builder: (fieldState) {
            final theme = Theme.of(context);

            return InputDecorator(
              decoration: InputDecoration(
                errorText: fieldState.errorText,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              child: InkWell(
                onTap: enabled
                    ? () {
                        final nextValue = !(fieldState.value ?? false);
                        fieldState.didChange(nextValue);
                        controller.setValue(field.name, nextValue);
                      }
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: CustomCheckBox(
                        value: fieldState.value ?? false,
                        onChanged: enabled
                            ? (value) {
                                fieldState.didChange(value ?? false);
                                controller.setValue(field.name, value ?? false);
                              }
                            : null,
                        isError: fieldState.hasError,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(field.label, style: theme.textTheme.bodyMedium),
                          if (field.helperText != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              field.helperText!,
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
    }
  }

  String? _initialTextValue(DynamicFormFieldSchema field) {
    final fromController = controller.values[field.name];
    if (fromController is String) return fromController;
    if (fromController != null) return fromController.toString();

    final init = field.initialValue;
    if (init == null) return null;
    return init.toString();
  }

  String? _initialSelectValue(DynamicFormFieldSchema field) {
    final fromController = controller.values[field.name];
    if (fromController == null) return null;
    return fromController.toString();
  }

  bool _initialBoolValue(DynamicFormFieldSchema field) {
    final fromController = controller.values[field.name];
    if (fromController is bool) return fromController;
    if (fromController != null) return fromController.toString() == 'true';
    if (field.initialValue is bool) return field.initialValue as bool;
    return false;
  }

  String? _validateText(String? value, DynamicFormFieldSchema field, S l10n) {
    return _firstError([
      field.required
          ? FormValidator.validateRequiredField(value, l10n: l10n)
          : null,
      if (field.minLength != null)
        FormValidator.validateMinLength(value, minLength: field.minLength!),
      if (field.maxLength != null)
        FormValidator.validateMaxLength(value, maxLength: field.maxLength!),
      if (field.pattern != null)
        FormValidator.validatePattern(value, pattern: field.pattern!),
    ]);
  }

  String? _validatePhone(String? value, DynamicFormFieldSchema field, S l10n) {
    final baseError = field.required
        ? FormValidator.validatePhone(value, l10n: l10n)
        : FormValidator.validatePattern(
            value,
            pattern: field.pattern ?? r'^\+?[0-9]{7,15}$',
            error: l10n.phoneInvalid,
          );

    return _firstError([
      baseError,
      if (field.pattern != null)
        FormValidator.validatePattern(
          value,
          pattern: field.pattern!,
          error: l10n.phoneInvalid,
        ),
      if (field.maxLength != null)
        FormValidator.validateMaxLength(value, maxLength: field.maxLength!),
    ]);
  }

  String? _validateEmail(String? value, DynamicFormFieldSchema field, S l10n) {
    final trimmed = value?.trim() ?? '';
    final baseError = trimmed.isEmpty && !field.required
        ? null
        : FormValidator.validateEmail(trimmed, l10n: l10n);

    return _firstError([
      baseError,
      if (field.maxLength != null)
        FormValidator.validateMaxLength(value, maxLength: field.maxLength!),
      if (field.pattern != null)
        FormValidator.validatePattern(value, pattern: field.pattern!),
    ]);
  }

  String? _validateNumber(String? value, DynamicFormFieldSchema field, S l10n) {
    final parsed = _tryParseInt(value);

    return _firstError([
      FormValidator.validateInteger(
        value,
        requiredError: field.required
            ? FormValidator.validateRequiredField(value, l10n: l10n)
            : null,
      ),
      FormValidator.validateIntegerRange(
        parsed,
        min: field.min,
        max: field.max,
      ),
    ]);
  }

  String? _validateSelect(String? value, DynamicFormFieldSchema field, S l10n) {
    if (!field.required) {
      return null;
    }
    return FormValidator.validateRequiredField(value, l10n: l10n);
  }

  String? _validateCheckbox(bool? value, DynamicFormFieldSchema field, S l10n) {
    if (!field.required) {
      return null;
    }
    return FormValidator.validateRequiredTrue(value, l10n: l10n);
  }

  int? _tryParseInt(String? raw) {
    final v = raw?.trim();
    if (v == null || v.isEmpty) return null;
    return int.tryParse(v);
  }

  String? _firstError(List<String?> validations) {
    for (final validation in validations) {
      if (validation != null) {
        return validation;
      }
    }
    return null;
  }
}
