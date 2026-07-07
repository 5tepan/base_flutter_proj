import 'package:base_flutter_proj/core/components/calendar/app_calendar_day_marker.dart';
import 'package:base_flutter_proj/core/components/calendar/app_calendar_selection.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppCalendarState {
  const AppCalendarState({
    required this.selection,
    this.markers = const {},
  });

  final AppCalendarSelection selection;
  final Map<String, AppCalendarDayMarker> markers;

  factory AppCalendarState.initial(AppCalendarSelectionMode mode) {
    return AppCalendarState(
      selection: AppCalendarSelection(mode: mode),
    );
  }

  AppCalendarState copyWith({
    AppCalendarSelection? selection,
    Map<String, AppCalendarDayMarker>? markers,
  }) {
    return AppCalendarState(
      selection: selection ?? this.selection,
      markers: markers ?? this.markers,
    );
  }
}
