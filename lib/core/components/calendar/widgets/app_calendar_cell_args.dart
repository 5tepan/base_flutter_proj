import 'package:base_flutter_proj/core/components/calendar/model/app_calendar_day_marker.dart';
import 'package:flutter/material.dart';

class AppCalendarCellArgs {
  const AppCalendarCellArgs({
    required this.sizeCell,
    required this.date,
    required this.data,
    required this.isOutsideMonth,
    required this.isSelected,
    required this.isInRange,
    required this.selectionColor,
  });

  final double sizeCell;
  final DateTime date;
  final AppCalendarDayMarker? data;
  final bool isOutsideMonth;
  final bool isSelected;
  final bool isInRange;
  final Color selectionColor;
}

typedef AppCalendarCellBuilder =
    Widget? Function(BuildContext context, AppCalendarCellArgs args);

typedef AppCalendarCellTapCallback =
    void Function(DateTime date, AppCalendarDayMarker? data);
