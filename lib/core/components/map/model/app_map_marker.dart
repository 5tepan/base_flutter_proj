import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';

/// Маркер (placemark) на карте.
class AppMapMarker {
  const AppMapMarker({
    required this.id,
    required this.point,
    this.title,
  });

  final String id;
  final AppMapPoint point;
  final String? title;
}
