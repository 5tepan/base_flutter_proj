import 'package:base_flutter_proj/core/components/map/model/app_map_camera.dart';
import 'package:base_flutter_proj/core/components/map/model/app_map_point.dart';

/// Конфиг экрана выбора точки на карте.
class AppMapPickConfig {
  const AppMapPickConfig({
    this.initialCamera = AppMapCamera.moscow,
    this.initialPoint,
    this.title,
    this.confirmLabel,
    this.autoLocateOnOpen = true,
  });

  final AppMapCamera initialCamera;
  final AppMapPoint? initialPoint;
  final String? title;
  final String? confirmLabel;
  final bool autoLocateOnOpen;
}
