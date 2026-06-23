import 'package:intl/intl.dart';

const monthShorthands = [
  "янв.",
  "февр.",
  "марта",
  "апр.",
  "мая",
  "июня",
  "июля",
  "авг.",
  "сент.",
  "окт.",
  "нояб.",
  "дек.",
];

extension DateTimeHelper on DateTime {
  bool isSameDay(DateTime sameDate) {
    return DateTime(year, month, day) ==
        DateTime(sameDate.year, sameDate.month, sameDate.day);
  }

  bool isToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(year, month, day) == today;
  }

  DateTime get onlyDate => DateTime(year, month, day);

  bool isYesterday() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    return DateTime(year, month, day) == yesterday;
  }

  bool isCurrentYear() {
    final now = DateTime.now();
    return year == now.year;
  }

  String formattedWithFormat(String format) {
    final formatter = DateFormat(format, 'ru_RU');
    return formatter.format(this);
  }

  String formatDateTime() {
    return formattedWithFormat('dd.MM.yyyy HH:mm');
  }

  String formatTime() {
    return formattedWithFormat('HH:mm');
  }

  String formatDate() {
    return formattedWithFormat('dd.MM.yyyy');
  }

  String formatDayAndMonth() {
    return formattedWithFormat('dd.MM');
  }

  String formatDateAndTime() {
    return formattedWithFormat('dd MMMM, HH:mm');
  }

  String formatDateAndTimeFull() {
    return formattedWithFormat('dd MMMM yyyy, HH:mm');
  }

  String formatSmartDayTime() {
    if (isToday()) {
      return formatTime();
    } else if (isYesterday()) {
      return 'Вчера';
    } else if (isCurrentYear()) {
      return formatDayAndMonth();
    } else {
      return formatDate();
    }
  }

  static String formatDurationToMmSs(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  bool isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(this);
    return isAtSameMomentAs | date.isAfter(dateTime);
  }

  bool isBeforeOrEqualTo(DateTime dateTime) {
    final isAtSameMomentAs = dateTime.isAtSameMomentAs(this);
    return isAtSameMomentAs | isBefore(dateTime);
  }

  bool isBetween(DateTime fromDateTime, DateTime toDateTime) {
    final isAfter = isAfterOrEqualTo(fromDateTime);
    final isBefore = isBeforeOrEqualTo(toDateTime);
    return isAfter && isBefore;
  }

  static String formatSecondsToMmSs(int seconds) {
    final sec = seconds % 60;
    final min = (seconds / 60).floor();
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(min.remainder(60));
    final twoDigitSeconds = twoDigits(sec.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatNameDateMonth() {
    final result = formattedWithFormat('E, dd MMM').split(" ");
    return [
      "${result.first.substring(0, 1).toUpperCase()}${result.first.substring(1)}",
      result[1],
      monthShorthands[month - 1],
    ].join(" ");
  }
}
