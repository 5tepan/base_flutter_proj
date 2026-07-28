import 'package:base_flutter_proj/core/components/map/config/app_map_config.dart';

/// Конфиг компактного превью карты.
class AppMapPreviewConfig {
  const AppMapPreviewConfig({
    required this.map,
    this.height = 180,
    this.interactive = false,
    this.openFullscreenOnTap = true,
    this.borderRadius = 12,
  });

  final AppMapConfig map;
  final double height;

  /// `false` — жесты выкл.; тап открывает fullscreen (если [openFullscreenOnTap]).
  final bool interactive;

  final bool openFullscreenOnTap;
  final double borderRadius;
}
