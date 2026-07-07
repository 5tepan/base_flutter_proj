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
    switch (mode) {
      case AppCalendarSelectionMode.none:
        return this;
      case AppCalendarSelectionMode.single:
        return AppCalendarSelection(mode: mode, startDate: date);
      case AppCalendarSelectionMode.range:
        return _selectRange(date);
    }
  }

  AppCalendarSelection clear() {
    return AppCalendarSelection(mode: mode);
  }

  AppCalendarSelection _selectRange(DateTime date) {
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

    return (date.isAtSameMomentAs(startDate!) || date.isAfter(startDate!)) &&
        (date.isAtSameMomentAs(endDate!) || date.isBefore(endDate!));
  }

  bool isSelected(DateTime date) {
    return startDate != null && date.isAtSameMomentAs(startDate!) ||
        endDate != null && date.isAtSameMomentAs(endDate!);
  }
}
