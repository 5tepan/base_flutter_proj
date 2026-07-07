import 'package:base_flutter_proj/core/components/calendar/app_calendar_helper.dart';

class AppCalendarWeeksData {
  final Map<String, Map<String, AppCalendarWeek>> _map = {};

  Iterable<AppCalendarWeek> getMonth(DateTime date) {
    return _map[AppCalendarHelper.monthKey(date)]?.values ??
        const Iterable<AppCalendarWeek>.empty();
  }

  DateTime createMonthFromIndex(int index) {
    final today = AppCalendarHelper.dateNow();
    final month = DateTime(today.year, today.month + index);
    _addMonth(month);
    return month;
  }

  void _addMonth(DateTime date) {
    final monthKey = AppCalendarHelper.monthKey(date);
    if (_map.containsKey(monthKey)) {
      return;
    }

    final monthData = _map.putIfAbsent(monthKey, () => {});
    var current = DateTime(date.year, date.month);
    final lastDateOfMonth = DateTime(date.year, date.month + 1, 0);

    while (current.isBefore(lastDateOfMonth) ||
        current.isAtSameMomentAs(lastDateOfMonth)) {
      final weekKey = AppCalendarHelper.weekKey(current);
      monthData.putIfAbsent(weekKey, () => _createWeek(current));
      current = current.add(const Duration(days: 1));
    }
  }

  AppCalendarWeek _createWeek(DateTime date) {
    return AppCalendarWeek(
      startDate: AppCalendarHelper.getMonday(date),
      endDate: AppCalendarHelper.getSunday(date),
      monthDate: DateTime(date.year, date.month),
    );
  }
}

class AppCalendarWeek {
  const AppCalendarWeek({
    required this.startDate,
    required this.endDate,
    required this.monthDate,
  });

  final DateTime startDate;
  final DateTime endDate;
  final DateTime monthDate;

  bool isOutsideMonth(DateTime date) {
    return date.month != monthDate.month || date.year != monthDate.year;
  }
}
