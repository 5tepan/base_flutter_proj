import 'package:flutter/material.dart';

/// Дополнительные данные для отображения на конкретной дате.
class AppCalendarDayMarker {
  const AppCalendarDayMarker({
    required this.date,
    this.color,
    this.badgeColor,
    this.metadata,
  });

  final DateTime date;
  final Color? color;
  final Color? badgeColor;
  final Object? metadata;
}
