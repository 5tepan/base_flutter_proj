import 'package:base_flutter_proj/core/components/calendar/app_calendar_config.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_day_marker.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_helper.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_state.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_weeks_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appCalendarNotifierProvider = NotifierProvider.family<
    AppCalendarNotifier,
    AppCalendarState,
    AppCalendarConfig>(AppCalendarNotifier.new);

class AppCalendarNotifier extends Notifier<AppCalendarState> {
  AppCalendarNotifier(this.config);

  final AppCalendarConfig config;
  final AppCalendarWeeksData weeksData = AppCalendarWeeksData();

  @override
  AppCalendarState build() {
    return AppCalendarState.initial(config.selectionMode);
  }

  void setMarkers(List<AppCalendarDayMarker> items) {
    final markers = <String, AppCalendarDayMarker>{};
    for (final item in items) {
      markers[AppCalendarHelper.dayKey(item.date)] = item;
    }
    state = state.copyWith(markers: markers);
  }

  void select(DateTime date) {
    state = state.copyWith(selection: state.selection.select(date));
  }

  void clearSelection() {
    state = state.copyWith(selection: state.selection.clear());
  }
}
