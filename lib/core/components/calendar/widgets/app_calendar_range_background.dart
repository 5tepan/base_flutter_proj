import 'package:base_flutter_proj/core/components/calendar/config/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/model/app_calendar_selection.dart';
import 'package:base_flutter_proj/core/components/calendar/model/app_calendar_weeks_data.dart';
import 'package:base_flutter_proj/core/components/calendar/utils/app_calendar_helper.dart';
import 'package:flutter/material.dart';

class AppCalendarRangeBackground extends StatelessWidget {
  const AppCalendarRangeBackground({
    super.key,
    required this.config,
    required this.selection,
    required this.weekData,
    required this.sizeCell,
    required this.spacing,
  });

  final AppCalendarConfig config;
  final AppCalendarSelection selection;
  final AppCalendarWeek weekData;
  final double sizeCell;
  final double spacing;

  static const _daysInWeek = 7;
  static const _radius = Radius.circular(8);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _AppCalendarRangeBackgroundPainter(
          config: config,
          selection: selection,
          weekData: weekData,
          sizeCell: sizeCell,
          spacing: spacing,
        ),
      ),
    );
  }
}

class _AppCalendarRangeBackgroundPainter extends CustomPainter {
  const _AppCalendarRangeBackgroundPainter({
    required this.config,
    required this.selection,
    required this.weekData,
    required this.sizeCell,
    required this.spacing,
  });

  final AppCalendarConfig config;
  final AppCalendarSelection selection;
  final AppCalendarWeek weekData;
  final double sizeCell;
  final double spacing;

  bool _shouldSkip(DateTime date) {
    if (!selection.isInRange(date)) {
      return true;
    }

    if (config.outsideMode == AppCalendarOutsideMonthDaysMode.hidden &&
        weekData.isOutsideMonth(date)) {
      return true;
    }

    return false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final start = selection.startDate;
    final end = selection.endDate;
    if (start == null || end == null) {
      return;
    }

    int? firstIndex;
    int? lastIndex;

    for (var i = 0; i < AppCalendarRangeBackground._daysInWeek; i++) {
      final date = weekData.startDate.add(Duration(days: i));
      if (_shouldSkip(date)) {
        continue;
      }

      firstIndex ??= i;
      lastIndex = i;
    }

    if (firstIndex == null || lastIndex == null) {
      return;
    }

    final left = firstIndex * (sizeCell + spacing);
    final right = lastIndex * (sizeCell + spacing) + sizeCell;
    final rect = Rect.fromLTRB(left, 0, right, sizeCell);
    final isWeekStart =
        firstIndex == 0 ||
        !AppCalendarHelper.isSameDay(
          weekData.startDate.add(Duration(days: firstIndex - 1)),
          start,
        );
    final isWeekEnd =
        lastIndex == AppCalendarRangeBackground._daysInWeek - 1 ||
        !AppCalendarHelper.isSameDay(
          weekData.startDate.add(Duration(days: lastIndex + 1)),
          end,
        );

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        rect,
        topLeft: isWeekStart ? AppCalendarRangeBackground._radius : Radius.zero,
        bottomLeft: isWeekStart
            ? AppCalendarRangeBackground._radius
            : Radius.zero,
        topRight: isWeekEnd ? AppCalendarRangeBackground._radius : Radius.zero,
        bottomRight: isWeekEnd
            ? AppCalendarRangeBackground._radius
            : Radius.zero,
      ),
      Paint()..color = config.selectionColor,
    );
  }

  @override
  bool shouldRepaint(covariant _AppCalendarRangeBackgroundPainter oldDelegate) {
    return oldDelegate.selection != selection ||
        oldDelegate.config != config ||
        oldDelegate.weekData != weekData;
  }
}
