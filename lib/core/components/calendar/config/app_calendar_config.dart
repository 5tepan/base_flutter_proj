import 'package:base_flutter_proj/core/components/calendar/model/app_calendar_selection.dart';
import 'package:base_flutter_proj/core/components/calendar/utils/app_calendar_helper.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Отображение дней соседних месяцев в сетке.
enum AppCalendarOutsideMonthDaysMode { visible, hidden }

/// Визуальные и поведенческие настройки календаря.
class AppCalendarConfig {
  const AppCalendarConfig({
    required this.minMonth,
    required this.maxMonth,
    this.selectionMode = AppCalendarSelectionMode.range,
    this.outsideMode = AppCalendarOutsideMonthDaysMode.hidden,
    this.selectionColor = AppColors.primaryLight,
  });

  /// `null` — без ограничения в прошлое.
  final DateTime? minMonth;

  /// `null` — без ограничения в будущее.
  final DateTime? maxMonth;
  final AppCalendarSelectionMode selectionMode;
  final AppCalendarOutsideMonthDaysMode outsideMode;
  final Color selectionColor;

  factory AppCalendarConfig.standard() {
    final today = AppCalendarHelper.dateNow();
    return AppCalendarConfig(
      minMonth: DateTime(today.year - 2, today.month),
      maxMonth: DateTime(today.year + 2, today.month),
    );
  }

  int? get minIndex {
    if (minMonth == null) {
      return null;
    }
    final now = AppCalendarHelper.dateNow();
    return (now.year - minMonth!.year) * 12 + (now.month - minMonth!.month);
  }

  int? get maxIndex {
    if (maxMonth == null) {
      return null;
    }
    final now = AppCalendarHelper.dateNow();
    return (maxMonth!.year - now.year) * 12 + (maxMonth!.month - now.month);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppCalendarConfig &&
            minMonth == other.minMonth &&
            maxMonth == other.maxMonth &&
            selectionMode == other.selectionMode &&
            outsideMode == other.outsideMode &&
            selectionColor == other.selectionColor;
  }

  @override
  int get hashCode => Object.hash(
    minMonth,
    maxMonth,
    selectionMode,
    outsideMode,
    selectionColor,
  );
}
