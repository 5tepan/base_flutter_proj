import 'package:base_flutter_proj/core/components/calendar/config/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/provider/app_calendar_notifier.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_cell_args.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_infinity_list_view.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCalendarListView extends ConsumerWidget {
  const AppCalendarListView({
    super.key,
    required this.config,
    required this.cellBuilder,
    required this.separatorBuilder,
    this.padding = EdgeInsets.zero,
    this.onTapCell,
  });

  final AppCalendarConfig config;
  final AppCalendarCellBuilder cellBuilder;
  final Widget Function(BuildContext context, int? index) separatorBuilder;
  final EdgeInsets padding;
  final AppCalendarCellTapCallback? onTapCell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(appCalendarNotifierProvider(config));

    return LayoutBuilder(
      builder: (context, constraints) {
        final innerConstraints = constraints.deflate(padding);

        return AppCalendarInfinityListView.separated(
          padding: padding,
          minIndex: config.minIndex,
          maxIndex: config.maxIndex,
          separatorBuilder: separatorBuilder,
          itemBuilder: (context, index) {
            final notifier = ref.read(
              appCalendarNotifierProvider(config).notifier,
            );
            return AppCalendarMonth(
              config: config,
              month: notifier.weeksData.createMonthFromIndex(index),
              constraints: innerConstraints,
              cellBuilder: cellBuilder,
              onTapCell: onTapCell,
            );
          },
        );
      },
    );
  }
}
