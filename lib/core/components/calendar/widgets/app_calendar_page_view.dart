import 'package:base_flutter_proj/core/components/calendar/config/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/provider/app_calendar_notifier.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_cell_args.dart';
import 'package:base_flutter_proj/core/components/calendar/widgets/app_calendar_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppCalendarPageView extends ConsumerStatefulWidget {
  const AppCalendarPageView({
    super.key,
    required this.config,
    required this.cellBuilder,
    this.padding = const EdgeInsets.all(16),
    this.onTapCell,
  });

  final AppCalendarConfig config;
  final AppCalendarCellBuilder cellBuilder;
  final EdgeInsets padding;
  final AppCalendarCellTapCallback? onTapCell;

  @override
  ConsumerState<AppCalendarPageView> createState() =>
      _AppCalendarPageViewState();
}

class _AppCalendarPageViewState extends ConsumerState<AppCalendarPageView> {
  static final _initialIndex = DateTime.now().year * 12;

  late final PageController _pageController = PageController(
    initialPage: _initialIndex,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appCalendarNotifierProvider(widget.config));

    return LayoutBuilder(
      builder: (context, constraints) {
        final innerConstraints = constraints.deflate(widget.padding);

        return PageView.builder(
          controller: _pageController,
          itemBuilder: (context, index) {
            final monthIndex = index - _initialIndex;
            final notifier = ref.read(
              appCalendarNotifierProvider(widget.config).notifier,
            );

            return Padding(
              padding: widget.padding,
              child: AppCalendarMonth(
                config: widget.config,
                month: notifier.weeksData.createMonthFromIndex(monthIndex),
                constraints: innerConstraints,
                cellBuilder: widget.cellBuilder,
                onTapCell: widget.onTapCell,
              ),
            );
          },
        );
      },
    );
  }
}
