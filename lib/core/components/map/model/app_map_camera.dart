import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';

/// Позиция камеры карты.
class AppMapCamera {
  const AppMapCamera({
    required this.target,
    this.zoom = 12,
    this.azimuth = 0,
    this.tilt = 0,
  });

  /// Москва — дефолт для демо без геолокации.
  static const AppMapCamera moscow = AppMapCamera(
    target: AppMapPoint(latitude: 55.751244, longitude: 37.618423),
    zoom: 11,
  );

  final AppMapPoint target;
  final double zoom;
  final double azimuth;
  final double tilt;

  AppMapCamera copyWith({
    AppMapPoint? target,
    double? zoom,
    double? azimuth,
    double? tilt,
  }) {
    return AppMapCamera(
      target: target ?? this.target,
      zoom: zoom ?? this.zoom,
      azimuth: azimuth ?? this.azimuth,
      tilt: tilt ?? this.tilt,
    );
  }
}
