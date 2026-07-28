import 'package:base_flutter_proj/core/components/map/controller/app_map_controller.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Кнопки управления картой: zoom, my location, compass, traffic.
class AppMapControls extends StatelessWidget {
  const AppMapControls({
    required this.controller,
    super.key,
    this.showZoom = true,
    this.showMyLocation = true,
    this.showCompass = true,
    this.showTraffic = true,
    this.onMyLocation,
    this.trafficVisible = false,
    this.alignment = Alignment.centerRight,
    this.padding = const EdgeInsets.only(right: 12),
  });

  final AppMapController controller;
  final bool showZoom;
  final bool showMyLocation;
  final bool showCompass;
  final bool showTraffic;
  final VoidCallback? onMyLocation;
  final bool trafficVisible;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.lightBlack : AppColors.white;
    final fg = isDark ? AppColors.white : AppColors.lightBlack;

    return Align(
      alignment: alignment,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showZoom) ...[
              _MapControlButton(
                icon: Icons.add,
                background: bg,
                foreground: fg,
                onPressed: controller.zoomIn,
              ),
              const SizedBox(height: 8),
              _MapControlButton(
                icon: Icons.remove,
                background: bg,
                foreground: fg,
                onPressed: controller.zoomOut,
              ),
              const SizedBox(height: 12),
            ],
            if (showMyLocation) ...[
              _MapControlButton(
                icon: Icons.my_location,
                background: bg,
                foreground: fg,
                onPressed: onMyLocation,
              ),
              const SizedBox(height: 8),
            ],
            if (showCompass) ...[
              _MapControlButton(
                icon: Icons.explore_outlined,
                background: bg,
                foreground: fg,
                onPressed: controller.resetNorth,
              ),
              const SizedBox(height: 8),
            ],
            if (showTraffic)
              _MapControlButton(
                icon: Icons.traffic_outlined,
                background: trafficVisible ? AppColors.primaryColor : bg,
                foreground: trafficVisible ? AppColors.white : fg,
                onPressed: controller.toggleTraffic,
              ),
          ],
        ),
      ),
    );
  }
}

class _MapControlButton extends StatelessWidget {
  const _MapControlButton({
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onPressed,
  });

  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: foreground, size: 22),
        ),
      ),
    );
  }
}
