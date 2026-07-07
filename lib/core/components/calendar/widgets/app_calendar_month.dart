import 'package:base_flutter_proj/core/components/calendar/config/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/provider/app_calendar_notifier.dart';
import 'package:base_flutter_proj/core/components/calendar/utils/app_calendar_helper.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_cell_args.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_line_month.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class AppCalendarMonth extends ConsumerWidget {
  const AppCalendarMonth({
    super.key,
    required this.config,
    required this.month,
    required this.constraints,
    required this.cellBuilder,
    this.onTapCell,
  });

  final AppCalendarConfig config;
  final DateTime month;
  final BoxConstraints constraints;
  final AppCalendarCellBuilder cellBuilder;
  final AppCalendarCellTapCallback? onTapCell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(appCalendarNotifierProvider(config).notifier);
    final state = ref.watch(appCalendarNotifierProvider(config));
    final (sizeCell, spacing) = AppCalendarHelper.getSizeAndSpacing(
      constraints,
    );
    final monthData = notifier.weeksData.getMonth(month);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MonthName(month: month),
        Gap(spacing),
        _WeekdayLabels(sizeCell: sizeCell, spacing: spacing),
        Gap(spacing),
        for (final weekData in monthData) ...[
          AppCalendarLineMonth(
            config: config,
            sizeCell: sizeCell,
            spacing: spacing,
            weekData: weekData,
            selection: state.selection,
            markers: state.markers,
            cellBuilder: cellBuilder,
            onTapCell: onTapCell,
          ),
          Gap(spacing),
        ],
      ],
    );
  }
}

class _MonthName extends StatelessWidget {
  const _MonthName({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return Text(
      toBeginningOfSentenceCase(
        DateFormat('LLLL yyyy', locale.toLanguageTag()).format(month),
      ),
      style: AppTextStyle.title,
    );
  }
}

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels({
    required this.sizeCell,
    required this.spacing,
  });

  final double sizeCell;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final labels = AppCalendarHelper.weekDayLabels(
      Localizations.localeOf(context),
    );

    return Row(
      children: [
        for (var index = 0; index < labels.length; index++) ...[
          if (index > 0) SizedBox(width: spacing),
          SizedBox(
            width: sizeCell,
            child: Align(
              child: Text(labels[index], style: AppTextStyle.body),
            ),
          ),
        ],
      ],
    );
  }
}
