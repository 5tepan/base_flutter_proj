import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract final class AppCalendarHelper {
  static List<String> weekDayLabels(Locale locale) {
    final formatter = DateFormat('E', locale.toLanguageTag());
    final monday = getMonday(DateTime.now());
    return List.generate(7, (index) {
      return formatter.format(monday.add(Duration(days: index)));
    });
  }

  static DateTime dateNow() {
    final dateTimeNow = DateTime.now();
    return dateOnly(dateTimeNow);
  }

  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime getMonday(DateTime date) {
    final daysToSubtract = date.weekday - 1;
    return date.subtract(Duration(days: daysToSubtract));
  }

  static DateTime getSunday(DateTime date) {
    var daysUntilSunday = DateTime.sunday - date.weekday;
    if (daysUntilSunday < 0) {
      daysUntilSunday += 7;
    }
    return date.add(Duration(days: daysUntilSunday));
  }

  static (double size, double spacing) getSizeAndSpacing(
    BoxConstraints constraints, {
    double baseSize = 38,
    double baseSpacing = 8.83,
  }) {
    final unit = constraints.maxWidth / ((7 * baseSize) + (6 * baseSpacing));
    return (unit * baseSize, unit * baseSpacing);
  }

  static String dayKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  static String monthKey(DateTime date) => '${date.year}-${date.month}';

  static String weekKey(DateTime date, {int? weekNumber}) {
    return '${weekNumber ?? _weekNumber(date)}';
  }

  static int _weekNumber(DateTime date) {
    final firstWeekday = DateTime(date.year, date.month).weekday;
    return ((date.day + (firstWeekday - 1) - 1) ~/ 7) + 1;
  }
}
