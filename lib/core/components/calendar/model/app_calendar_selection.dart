import 'package:base_flutter_proj/core/components/calendar/utils/app_calendar_helper.dart';

/// Режим выбора дат в календаре.
enum AppCalendarSelectionMode { none, single, range }

/// Неизменяемое состояние выбранных дат.
class AppCalendarSelection {
  const AppCalendarSelection({
    this.mode = AppCalendarSelectionMode.range,
    this.startDate,
    this.endDate,
  });

  final AppCalendarSelectionMode mode;
  final DateTime? startDate;
  final DateTime? endDate;

  bool get isEmpty => startDate == null && endDate == null;

  bool get hasSingle => startDate != null && endDate == null;

  bool get hasRange => startDate != null && endDate != null;

  AppCalendarSelection select(DateTime date) {
    final normalized = AppCalendarHelper.dateOnly(date);

    switch (mode) {
      case AppCalendarSelectionMode.none:
        return this;
      case AppCalendarSelectionMode.single:
        if (startDate != null &&
            AppCalendarHelper.isSameDay(startDate!, normalized)) {
          return clear();
        }
        return AppCalendarSelection(mode: mode, startDate: normalized);
      case AppCalendarSelectionMode.range:
        return _selectRange(normalized);
    }
  }

  AppCalendarSelection clear() {
    return AppCalendarSelection(mode: mode);
  }

  AppCalendarSelection _selectRange(DateTime date) {
    if (isSelected(date)) {
      return clear();
    }

    if (startDate == null || (startDate != null && endDate != null)) {
      return AppCalendarSelection(mode: mode, startDate: date);
    }

    final first = startDate!;
    if (date.isBefore(first)) {
      return AppCalendarSelection(mode: mode, startDate: date, endDate: first);
    }

    return AppCalendarSelection(mode: mode, startDate: first, endDate: date);
  }

  bool isInRange(DateTime date) {
    if (startDate == null || endDate == null) {
      return false;
    }

    final normalized = AppCalendarHelper.dateOnly(date);
    return (AppCalendarHelper.isSameDay(normalized, startDate!) ||
            normalized.isAfter(startDate!)) &&
        (AppCalendarHelper.isSameDay(normalized, endDate!) ||
            normalized.isBefore(endDate!));
  }

  bool isSelected(DateTime date) {
    final normalized = AppCalendarHelper.dateOnly(date);
    return startDate != null &&
            AppCalendarHelper.isSameDay(normalized, startDate!) ||
        endDate != null && AppCalendarHelper.isSameDay(normalized, endDate!);
  }
}
