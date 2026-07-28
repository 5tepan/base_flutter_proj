import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';
import 'package:flutter/material.dart';

/// Полилиния как map object (список точек, без Directions API).
class AppMapPolyline {
  const AppMapPolyline({
    required this.id,
    required this.points,
    this.color,
    this.strokeWidth = 4,
  });

  final String id;
  final List<AppMapPoint> points;
  final Color? color;
  final double strokeWidth;
}
