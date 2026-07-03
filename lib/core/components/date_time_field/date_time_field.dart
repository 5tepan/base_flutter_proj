import 'dart:io';

import 'package:base_flutter_proj/core/components/date_time_field/bottom_picker_header.dart';
import 'package:base_flutter_proj/core/components/date_time_field/year_picker.dart';
import 'package:base_flutter_proj/core/helpers/date_time_helper.dart';
import 'package:base_flutter_proj/core/helpers/widget_extensions/simple_padding_extension.dart';
import 'package:base_flutter_proj/core/providers/theme_provider.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/context_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final DateTime _kDefaultFirstSelectableDate = DateTime(1900);
final DateTime _kDefaultLastSelectableDate = DateTime(2100);

enum DateTimeFieldPlatform { cupertino, material, adaptive }

/// [DateTimeField]
///
/// Shows an [_InputDropdown] that'll trigger [DateTimeField._selectDate] whenever the user
/// clicks on it ! The date picker is **platform responsive** (ios date picker style for ios, ...)
class DateTimeField extends ConsumerWidget {
  DateTimeField({
    super.key,
    required this.onDateSelected,
    required this.selectedDate,
    this.initialDatePickerMode = DatePickerMode.day,
    this.decoration,
    this.enabled = true,
    this.mode = DateTimeFieldPickerMode.dateAndTime,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.dateTextStyle,
    this.initialDate,
    this.platform = DateTimeFieldPlatform.adaptive,
    this.labelText,
    this.selectableDayPredicate,
    this.customFormatFunction,
    TextStyle? labelStyle,
    this.labelPadding = EdgeInsets.zero,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.dateTextStyleDisabled,
    this.minTime,
    this.maxTime,
    this.use24hFormat = true,
    this.minuteInterval = 1,
    this.useSafeArea = false,
    this.showPickerHeader = true,
    this.headerBuilder,
  }) : labelStyle = labelStyle ?? AppTextStyle.body,
       dateFormat = dateFormat ?? getDateFormatFromDateFieldPickerMode(mode),
       firstDate = firstDate ?? _kDefaultFirstSelectableDate,
       lastDate = lastDate ?? _kDefaultLastSelectableDate;

  DateTimeField.time({
    super.key,
    this.onDateSelected,
    this.minTime,
    this.maxTime,
    this.use24hFormat = true,
    this.selectedDate,
    this.decoration,
    this.enabled = true,
    this.initialDate,
    this.platform = DateTimeFieldPlatform.adaptive,
    this.dateTextStyle,
    this.dateTextStyleDisabled,
    this.labelText,
    this.selectableDayPredicate,
    this.customFormatFunction,
    TextStyle? labelStyle,
    this.labelPadding = EdgeInsets.zero,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    DateTime? firstDate,
    DateTime? lastDate,
    DateFormat? dateFormat,
    this.useSafeArea = false,
    this.showPickerHeader = true,
    this.headerBuilder,
    this.minuteInterval = 1,
  }) : labelStyle = labelStyle ?? AppTextStyle.body,
       initialDatePickerMode = null,
       mode = DateTimeFieldPickerMode.time,
       dateFormat = dateFormat ?? DateFormat.jm(),
       firstDate = firstDate ?? DateTime(2000),
       lastDate = lastDate ?? DateTime(2001);

  final DateTimeFieldPlatform platform;

  /// Callback for whenever the user selects a [DateTime]
  final ValueChanged<DateTime?>? onDateSelected;

  /// The current selected date to display inside the field
  final DateTime? selectedDate;

  /// Is use 24 hour format
  final bool use24hFormat;

  final Time? maxTime;
  final Time? minTime;

  /// Шаг выбора минут в пикере времени (1, 15, 30 …). Для [DateTimeFieldPickerMode.time]
  /// передаётся в [BottomPicker.time] и [CupertinoDatePicker].
  final int minuteInterval;

  /// The first date that the user can select (default is 1900)
  final DateTime firstDate;

  /// The last date that the user can select (default is 2100)
  final DateTime lastDate;

  /// The date that will be selected by default in the calendar view.
  final DateTime? initialDate;

  /// Let you choose the [DatePickerMode] for the date picker! (default is [DatePickerMode.day]
  final DatePickerMode? initialDatePickerMode;

  final SelectableDayPredicate? selectableDayPredicate;

  /// Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration? decoration;

  /// How to display the [DateTime] for the user (default is [DateFormat.yMMMD])
  final DateFormat dateFormat;

  final String Function(DateTime)? customFormatFunction;

  /// Whether the field is usable. If false the user won't be able to select any date
  final bool enabled;

  /// Whether to ask the user to pick only the date, the time or both.
  final DateTimeFieldPickerMode mode;

  /// [TextStyle] of the selected date inside the field.
  final TextStyle? dateTextStyle;

  final TextStyle? dateTextStyleDisabled;

  /// The initial entry mode for the material date picker dialog
  final DatePickerEntryMode initialEntryMode;

  /// Text field label
  final String? labelText;

  /// TextStyle for the label
  final TextStyle labelStyle;

  /// TextStyle for the label
  final EdgeInsets labelPadding;

  final bool useSafeArea;

  /// Показывать заголовок и кнопку закрытия в [BottomPicker.time].
  /// Если `false`, шапка не передаётся в пикер (см. [headerBuilder] для кастомной).
  final bool showPickerHeader;

  /// Кастомная шапка пикера времени. Используется только при [showPickerHeader] == true.
  /// Если `null`, показывается стандартная шапка «Выберите время».
  final Widget Function(BuildContext)? headerBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? text;

    if (selectedDate != null) {
      if (customFormatFunction != null) {
        text = customFormatFunction!(selectedDate!);
      } else {
        text = dateFormat.format(selectedDate!);
      }
    }

    return _InputDropdown(
      text: text,
      labelText: labelText,
      onDateSelected: onDateSelected,
      labelPadding: labelPadding,
      labelStyle: labelStyle,
      textStyle: enabled
          ? (dateTextStyle ?? AppTextStyle.body2)
          : dateTextStyleDisabled,
      isEmpty: selectedDate == null,
      decoration: decoration,
      onPressed: enabled ? () => _selectDate(context, ref) : null,
    );
  }

  /// Shows a dialog asking the user to pick a date !
  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    FocusScope.of(context).unfocus();
    final DateTime initialDateTime;

    if (selectedDate != null) {
      initialDateTime = selectedDate!;
    } else {
      final now = DateTime.now();
      if (firstDate.isAfter(now) || lastDate.isBefore(now)) {
        initialDateTime = initialDate ?? lastDate;
      } else {
        if (mode == DateTimeFieldPickerMode.date ||
            mode == DateTimeFieldPickerMode.year) {
          initialDateTime = now.onlyDate;
        } else {
          initialDateTime = now;
        }
      }
    }
    final selectedTime = await selectTimeViaPicker(context, initialDateTime, ref);
    if (selectedTime != null) {
      onDateSelected!(selectedTime);
    }
  }

  Future<DateTime?> selectTimeViaPicker(
    BuildContext context,
    DateTime initialDateTime,
    WidgetRef ref,
  ) async {
    if (mode == DateTimeFieldPickerMode.year ||
        platform == DateTimeFieldPlatform.material) {
      return _selectTimeViaMaterialPicker(context, initialDateTime, ref);
    } else if (platform == DateTimeFieldPlatform.cupertino) {
      return _selectTimeViaCupertinoPicker(context, initialDateTime);
    }
    return Platform.isIOS
        ? await _selectTimeViaCupertinoPicker(context, initialDateTime)
        : await _selectTimeViaMaterialPicker(context, initialDateTime, ref);
  }

  Future<DateTime?> _selectTimeViaCupertinoPicker(
    BuildContext context,
    DateTime initialDateTime,
  ) async {
    DateTime? selectable;
    return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext pickerContext) {
        return Container(
          color: AppColors.white,
          height: 0.6 * MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CupertinoButton(
                    padding: const EdgeInsets.only(top: 4, left: 16),
                    onPressed: () => Navigator.of(pickerContext).pop(),
                    child: Text(
                      "Отмена",
                      style: Theme.of(context).textTheme.bodyMedium?.apply(
                        color: AppColors.primaryColor,
                        fontWeightDelta: 2,
                        fontSizeFactor: 0.94,
                      ),
                    ),
                    minimumSize: const Size(40, 40),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(top: 4, right: 16),
                    onPressed: () => Navigator.of(
                      pickerContext,
                    ).pop(selectable ?? initialDateTime),
                    child: Text(
                      S.of(context).dateTimeSelect,
                      style: Theme.of(context).textTheme.bodyMedium?.apply(
                        color: AppColors.primaryColor,
                        fontWeightDelta: 2,
                        fontSizeFactor: 0.94,
                      ),
                    ),
                    minimumSize: const Size(40, 40),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoDatePicker(
                  use24hFormat: use24hFormat,
                  mode: _cupertinoModeFromPickerMode(mode),
                  minuteInterval: mode == DateTimeFieldPickerMode.time
                      ? minuteInterval
                      : 1,
                  onDateTimeChanged: (date) => selectable = date,
                  initialDateTime: initialDateTime,
                  minimumDate: firstDate,
                  maximumDate: lastDate,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget Function(BuildContext) get _emptyTimePickerHeaderBuilder =>
      (BuildContext _) => const SizedBox.shrink();

  Widget Function(BuildContext) get _resolveTimePickerHeaderBuilder {
    return headerBuilder ??
        (pickerContext) {
          return BottomPickerHeader(
            title: S.of(pickerContext).dateTimeSelectTime,
            backgroundColor: AppColors.grey,
            closeIconColor: AppColors.white,
            titleStyle: AppTextStyle.body.copyWith(color: AppColors.white),
            onClosePressed: () => Navigator.of(pickerContext).pop(),
          );
        };
  }

  Time get initialTime {
    final now = Time.now();
    final seed = selectedDate ?? initialDate;
    final initial = seed != null
        ? Time(hours: seed.hour, minutes: seed.minute)
        : now;

    if (minTime != null && initial.toDateTime.isBefore(minTime!.toDateTime)) {
      return minTime!;
    }
    if (maxTime != null && initial.toDateTime.isAfter(maxTime!.toDateTime)) {
      return maxTime!;
    }
    return initial;
  }

  Future<DateTime?> _selectTimeViaMaterialPicker(
    BuildContext context,
    DateTime initialDateTime,
    WidgetRef ref,
  ) async {
    var _selectedDateTime = initialDateTime;

    if (mode == DateTimeFieldPickerMode.time) {
      final picker = BottomPicker.time(
        buttonContent: Text(
          S.of(context).dateTimeSelect,
          textAlign: TextAlign.center,
        ),
        use24hFormat: use24hFormat,
        minuteInterval: minuteInterval,
        minTime: minTime,
        dismissable: true,
        maxTime: maxTime,
        backgroundColor: AppColors.grey,
        buttonSingleColor: AppColors.white,
        initialTime: initialTime,
        headerBuilder: showPickerHeader
            ? _resolveTimePickerHeaderBuilder
            : _emptyTimePickerHeaderBuilder,
        onSubmit: (time) {
          if (time is DateTime) {
            onDateSelected?.call(time);
          }
        },
      );
      _showBottomPicker(context, picker, insetForSystemNavigation: useSafeArea);

      return null;
    }

    const modesWithDate = <DateTimeFieldPickerMode>[
      DateTimeFieldPickerMode.dateAndTime,
      DateTimeFieldPickerMode.date,
    ];

    if (modesWithDate.contains(mode)) {
      final themeBuilder = ref.read(themeBuilderProvider);
      final _selectedDate = await showDatePicker(
        context: context,
        selectableDayPredicate: selectableDayPredicate,
        initialDatePickerMode: initialDatePickerMode!,
        initialDate: initialDateTime,
        initialEntryMode: initialEntryMode,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (BuildContext context, Widget? child) {
          return themeBuilder.buildDatePickerTheme(child: child!);
        },
      );

      if (_selectedDate != null) {
        _selectedDateTime = _selectedDate;
      } else {
        return null;
      }
    }

    final modesWithTime = <DateTimeFieldPickerMode>[
      DateTimeFieldPickerMode.dateAndTime,
      DateTimeFieldPickerMode.time,
    ];

    if (modesWithTime.contains(mode)) {
      if (!context.mounted) {
        return null;
      }
      final themeBuilder = ref.read(themeBuilderProvider);
      final _selectedTime = await showTimePicker(
        initialTime: TimeOfDay.fromDateTime(initialDateTime),
        context: context,
        builder: (context, child) {
          return themeBuilder.buildDatePickerTheme(child: child!);
        },
      );

      if (_selectedTime != null) {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      } else {
        return null;
      }
    }

    const modesWithYear = <DateTimeFieldPickerMode>[
      DateTimeFieldPickerMode.year,
    ];

    if (modesWithYear.contains(mode)) {
      if (!context.mounted) {
        return null;
      }
      final _selectedDate = await showYearPicker(
        context: context,
        selectedDate: _selectedDateTime,
        firstDate: firstDate,
        lastDate: lastDate,
      );

      if (_selectedDate != null) {
        _selectedDateTime = _selectedDate;
      } else {
        return null;
      }
    }
    onDateSelected!(_selectedDateTime);
    return _selectedDateTime;
  }
}

void _showBottomPicker(
  BuildContext context,
  BottomPicker picker, {
  required bool insetForSystemNavigation,
}) {
  showModalBottomSheet<void>(
    context: context,
    isDismissible: picker.dismissable,
    enableDrag: false,
    constraints: BoxConstraints(maxWidth: context.bottomPickerWidth),
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      Widget child = picker;
      if (insetForSystemNavigation) {
        final bottomInset = MediaQuery.viewPaddingOf(sheetContext).bottom;
        if (bottomInset > 0) {
          child = ColoredBox(
            color: picker.backgroundColor,
            child: Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: picker,
            ),
          );
        }
      }

      return BottomSheet(
        backgroundColor: Colors.transparent,
        enableDrag: false,
        onClosing: () {},
        builder: (_) => child,
      );
    },
  );
}

/// Those values are used by the [DateTimeField] widget to determine whether to ask
/// the user for the time, the date or both.
enum DateTimeFieldPickerMode { time, date, dateAndTime, year }

/// Returns the [CupertinoDatePickerMode] corresponding to the selected
/// [DateTimeFieldPickerMode]. This exists to prevent redundancy in the [DateTimeField]
/// widget parameters.
CupertinoDatePickerMode _cupertinoModeFromPickerMode(
  DateTimeFieldPickerMode mode,
) {
  switch (mode) {
    case DateTimeFieldPickerMode.time:
      return CupertinoDatePickerMode.time;
    case DateTimeFieldPickerMode.date:
      return CupertinoDatePickerMode.date;
    default:
      return CupertinoDatePickerMode.dateAndTime;
  }
}

/// Returns the corresponding default [DateFormat] for the selected [DateTimeFieldPickerMode]
DateFormat getDateFormatFromDateFieldPickerMode(DateTimeFieldPickerMode mode) {
  switch (mode) {
    case DateTimeFieldPickerMode.time:
      return DateFormat.jm();
    case DateTimeFieldPickerMode.date:
      return DateFormat.yMMMMd();
    case DateTimeFieldPickerMode.year:
      return DateFormat.y();
    default:
      return DateFormat.yMd().add_jm();
  }
}

///
/// [_InputDropdown]
///
/// Shows a field with a dropdown arrow !
/// It does not show any popup menu, it'll just trigger onPressed whenever the
/// user does click on it !
class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    required this.text,
    required this.isEmpty,
    this.onDateSelected,
    this.labelText,
    TextStyle? labelStyle,
    this.labelPadding = EdgeInsets.zero,
    this.decoration,
    this.textStyle,
    this.onPressed,
  }) : labelStyle = labelStyle ?? AppTextStyle.body;

  /// Callback for whenever the user selects a [DateTime]
  final ValueChanged<DateTime?>? onDateSelected;

  /// The text that should be displayed inside the field
  final String? text;

  /// The text that should be displayed on top of field
  final String? labelText;

  /// Custom [InputDecoration] for the [InputDecorator] widget
  final InputDecoration? decoration;

  /// TextStyle for the field
  final TextStyle? textStyle;

  /// TextStyle for the label
  final TextStyle labelStyle;

  /// TextStyle for the label
  final EdgeInsets labelPadding;

  /// Callbacks triggered whenever the user presses on the field!
  final VoidCallback? onPressed;

  /// Whether the input field is empty.
  ///
  /// Determines the position of the label text and whether to display the hint
  /// text.
  ///
  /// Defaults to false.
  final bool isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (labelText != null)
          Text(labelText!, style: labelStyle).allPadding(labelPadding),
        GestureDetector(
          onTap: onPressed,
          child: InputDecorator(
            decoration: decoration ?? ThemeBuilder.buildDateTimeFieldDecoration,
            isEmpty: isEmpty,
            isFocused: true,
            child: text == null ? null : Text(text!, style: textStyle),
          ),
        ),
      ],
    );
  }
}
