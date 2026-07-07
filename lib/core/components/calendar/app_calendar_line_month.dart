import 'package:base_flutter_proj/core/components/calendar/app_calendar_cell_args.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_day_marker.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_helper.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_notifier.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_range_background.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_selection.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_weeks_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCalendarLineMonth extends ConsumerWidget {
  const AppCalendarLineMonth({
    super.key,
    required this.config,
    required this.sizeCell,
    required this.spacing,
    required this.weekData,
    required this.selection,
    required this.markers,
    required this.cellBuilder,
    this.onTapCell,
  });

  final AppCalendarConfig config;
  final double sizeCell;
  final double spacing;
  final AppCalendarWeek weekData;
  final AppCalendarSelection selection;
  final Map<String, AppCalendarDayMarker> markers;
  final AppCalendarCellBuilder cellBuilder;
  final AppCalendarCellTapCallback? onTapCell;

  static const int _daysInWeek = 7;

  bool get _hideOutsideDays =>
      config.outsideMode == AppCalendarOutsideMonthDaysMode.hidden;

  bool get _isRangeMode =>
      config.selectionMode == AppCalendarSelectionMode.range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final row = Row(
      children: [
        for (var index = 0; index < _daysInWeek; index++) ...[
          if (index > 0) SizedBox(width: spacing),
          _buildCell(context, ref, index),
        ],
      ],
    );

    if (!_isRangeMode) {
      return row;
    }

    return Stack(
      children: [
        Positioned.fill(
          child: AppCalendarRangeBackground(
            config: config,
            selection: selection,
            weekData: weekData,
            sizeCell: sizeCell,
            spacing: spacing,
          ),
        ),
        row,
      ],
    );
  }

  Widget _buildCell(BuildContext context, WidgetRef ref, int index) {
    final date = weekData.startDate.add(Duration(days: index));
    final isOutside = weekData.isOutsideMonth(date);

    if (isOutside && _hideOutsideDays) {
      return SizedBox.square(dimension: sizeCell);
    }

    final data = markers[AppCalendarHelper.dayKey(date)];
    final args = AppCalendarCellArgs(
      sizeCell: sizeCell,
      date: date,
      data: data,
      isOutsideMonth: isOutside,
      isSelected: selection.isSelected(date),
      isInRange: selection.isInRange(date),
      selectionColor: config.selectionColor,
    );

    final child = cellBuilder(context, args);
    if (child == null) {
      return SizedBox.square(dimension: sizeCell);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onTapCell?.call(date, data);
        ref.read(appCalendarNotifierProvider(config).notifier).select(date);
      },
      child: child,
    );
  }
}
