import 'package:base_flutter_proj/core/components/map/config/app_map_config.dart';
import 'package:base_flutter_proj/core/components/map/config/app_map_preview_config.dart';
import 'package:base_flutter_proj/core/components/map/widgets/app_map_view.dart';
import 'package:flutter/material.dart';

/// Компактное превью карты (interactive / tap → fullscreen).
class AppMapPreview extends StatefulWidget {
  const AppMapPreview({
    required this.config,
    super.key,
    this.onOpenFullscreen,
    this.onTap,
  });

  final AppMapPreviewConfig config;
  final AppMapOpenFullscreen? onOpenFullscreen;
  final VoidCallback? onTap;

  @override
  State<AppMapPreview> createState() => _AppMapPreviewState();
}

class _AppMapPreviewState extends State<AppMapPreview> {
  Offset? _pointerDown;

  void _handleOpen() {
    widget.onTap?.call();
    if (widget.config.openFullscreenOnTap) {
      widget.onOpenFullscreen?.call(context, widget.config.map);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.config;
    final map = ClipRRect(
      borderRadius: BorderRadius.circular(config.borderRadius),
      child: SizedBox(
        height: config.height,
        width: double.infinity,
        child: AppMapView(
          config: config.map.copyWith(showControls: false),
          gesturesEnabled: config.interactive,
        ),
      ),
    );

    if (config.interactive) {
      return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event) => _pointerDown = event.localPosition,
        onPointerUp: (event) {
          final down = _pointerDown;
          _pointerDown = null;
          if (down == null) {
            return;
          }
          final delta = (event.localPosition - down).distance;
          if (delta < 8) {
            _handleOpen();
          }
        },
        child: map,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _handleOpen,
        borderRadius: BorderRadius.circular(config.borderRadius),
        child: IgnorePointer(child: map),
      ),
    );
  }
}
