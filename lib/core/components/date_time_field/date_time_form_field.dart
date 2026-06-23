import 'package:base_flutter_proj/core/components/date_time_field/date_time_field.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A [FormField] that contains a [DateTimeField].
///
/// This is a convenience widget that wraps a [DateTimeField] widget in a
/// [FormField].
///
/// A [Form] ancestor is not required. The [Form] simply makes it easier to
/// save, reset, or validate multiple fields at once. To use without a [Form],
/// pass a [GlobalKey] to the constructor and use [GlobalKey.currentState] to
/// save or reset the form field.
class DateTimeFormField extends FormField<DateTime> {
  DateTimeFormField({
    super.key,
    String? labelText,
    TextStyle? labelStyle,
    EdgeInsets labelPadding = EdgeInsets.zero,
    super.onSaved,
    super.validator,
    super.initialValue,
    super.autovalidateMode,
    super.enabled,
    TextStyle? dateTextStyle,
    DateFormat? dateFormat,
    DateTime? firstDate,
    DateTime? lastDate,
    DateTime? initialDate,
    String Function(DateTime)? customFormatFunction,
    ValueChanged<DateTime?>? onDateSelected,
    InputDecoration? decoration,
    DatePickerEntryMode initialEntryMode = DatePickerEntryMode.calendar,
    DatePickerMode initialDatePickerMode = DatePickerMode.day,
    DateTimeFieldPickerMode mode = DateTimeFieldPickerMode.dateAndTime,
  }) : super(
         builder: (FormFieldState<DateTime> field) {
           // Theme defaults are applied inside the _InputDropdown widget
           labelStyle ??= AppTextStyle.body.copyWith(
             fontSize: 14,
             fontWeight: FontWeight.w500,
           );
           final decorationWithThemeDefaults =
               decoration ?? ThemeBuilder.buildDateTimeFieldDecoration;

           final effectiveDecoration = decorationWithThemeDefaults.copyWith(
             errorText: field.errorText,
           );

           void onChangedHandler(DateTime? value) {
             if (onDateSelected != null) {
               onDateSelected(value);
             }
             field.didChange(value);
           }

           return DateTimeField(
             labelText: labelText,
             labelPadding: labelPadding,
             labelStyle: labelStyle,
             firstDate: firstDate,
             initialDate: initialDate,
             lastDate: lastDate,
             decoration: effectiveDecoration,
             initialDatePickerMode: initialDatePickerMode,
             dateFormat: dateFormat,
             onDateSelected: onChangedHandler,
             selectedDate: field.value,
             enabled: enabled,
             mode: mode,
             initialEntryMode: initialEntryMode,
             customFormatFunction: customFormatFunction,
             dateTextStyle: dateTextStyle,
           );
         },
       );

  @override
  _DateFormFieldState createState() => _DateFormFieldState();
}

class _DateFormFieldState extends FormFieldState<DateTime> {}
