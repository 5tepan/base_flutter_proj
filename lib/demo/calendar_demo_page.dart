import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_cell.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_cell_args.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_day_marker.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_helper.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_list_view.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_notifier.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_page_view.dart';
import 'package:base_flutter_proj/core/components/colored_card_widget.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/helpers/date_time_helper.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum _CalendarDemoMode { list, page }

/// Демо кастомного календаря: list и page режимы, выбор диапазона дат.
class CalendarDemoPage extends ConsumerStatefulWidget {
  const CalendarDemoPage({super.key});

  @override
  ConsumerState<CalendarDemoPage> createState() => _CalendarDemoPageState();
}

class _CalendarDemoPageState extends ConsumerState<CalendarDemoPage> {
  static final _listConfig = AppCalendarConfig(
    minMonth: DateTime(DateTime.now().year, DateTime.now().month - 4),
    maxMonth: DateTime(DateTime.now().year, DateTime.now().month + 4),
    selectionColor: AppColors.primaryLight,
  );

  static const _pageConfig = AppCalendarConfig(
    minMonth: null,
    maxMonth: null,
    outsideMode: AppCalendarOutsideMonthDaysMode.visible,
    selectionColor: AppColors.primaryLight,
  );

  _CalendarDemoMode _mode = _CalendarDemoMode.list;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDemoMarkers();
    });
  }

  void _loadDemoMarkers() {
    final markers = [
      AppCalendarDayMarker(
        date: DateTime.now().add(const Duration(days: 2)),
        color: AppColors.orange.withValues(alpha: 0.35),
      ),
      AppCalendarDayMarker(
        date: DateTime.now().add(const Duration(days: 4)),
        color: AppColors.blue.withValues(alpha: 0.35),
      ),
    ];

    ref.read(appCalendarNotifierProvider(_listConfig).notifier).setMarkers(
      markers,
    );
    ref.read(appCalendarNotifierProvider(_pageConfig).notifier).setMarkers(
      markers,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(
        title: l10n.demoCalendarTitle,
        actionsWidget: [
          PopupMenuButton<_CalendarDemoMode>(
            initialValue: _mode,
            onSelected: (value) => setState(() => _mode = value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _CalendarDemoMode.list,
                child: Text(l10n.demoCalendarListMode),
              ),
              PopupMenuItem(
                value: _CalendarDemoMode.page,
                child: Text(l10n.demoCalendarPageMode),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
            child: ColoredCardWidget(
              child: Text(
                l10n.demoCalendarSubtitle,
                style: AppTextStyle.small,
              ),
            ),
          ),
          Expanded(
            child: switch (_mode) {
              _CalendarDemoMode.list => AppCalendarListView(
                config: _listConfig,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                cellBuilder: _buildCell,
                separatorBuilder: _separatorBuilder,
                onTapCell: _onTapCell,
              ),
              _CalendarDemoMode.page => AppCalendarPageView(
                config: _pageConfig,
                cellBuilder: _buildCell,
                onTapCell: _onTapCell,
              ),
            },
          ),
        ],
      ),
    );
  }

  Widget _separatorBuilder(BuildContext context, int? index) {
    return const SizedBox(height: 36);
  }

  Widget? _buildCell(BuildContext context, AppCalendarCellArgs args) {
    return AppCalendarCell(
      text: '${args.date.day}',
      style: _cellStyle(args),
    );
  }

  AppCalendarCellStyle _cellStyle(AppCalendarCellArgs args) {
    final date = args.date;
    final today = date.isToday();
    final badgeColor = today ? AppColors.primaryColor : args.data?.badgeColor;
    var color = args.data?.color ?? AppColors.lightGrey;

    if (date.isBefore(AppCalendarHelper.dateNow())) {
      color = AppColors.midGrey.withValues(alpha: 0.35);
    }
    if (args.isOutsideMonth) {
      color = AppColors.black.withValues(alpha: 0.04);
    }
    if (args.isInRange) {
      color = args.selectionColor;
    }
    if (args.isSelected) {
      color = AppColors.darkGrey;
    }

    return AppCalendarCellStyle(
      size: args.sizeCell,
      color: color,
      badgeColor: badgeColor,
      textColor: args.isSelected ? AppColors.white : AppColors.black,
    );
  }

  void _onTapCell(DateTime date, AppCalendarDayMarker? data) {
    CustomLogger.info('Calendar tap: $date, marker: $data');
  }
}
