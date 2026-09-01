import 'package:base_flutter_proj/core/assets/app_asset.dart';
import 'package:base_flutter_proj/core/assets/app_icon.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

class MediaFeedGalleryIconButton extends StatelessWidget {
  const MediaFeedGalleryIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
  });

  final AppAsset icon;
  final VoidCallback onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.black.withValues(alpha: 0.45),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        icon: AppIcon(icon, color: AppColors.white),
      ),
    );
  }
}
