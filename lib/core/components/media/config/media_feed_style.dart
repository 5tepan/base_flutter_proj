import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Визуальные настройки [MediaFeedStrip].
class MediaFeedStyle {
  const MediaFeedStyle({
    this.itemSize = 88,
    this.spacing = 8,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor = AppColors.lightGrey,
    this.borderColor = AppColors.border,
    this.borderWidth = 1,
    this.addButtonIcon = Icons.add_a_photo_outlined,
    this.removeButtonIcon = Icons.close,
    this.removeButtonColor = AppColors.errorColor,
    this.removeButtonBackgroundColor = AppColors.white,
    this.videoOverlayIcon = Icons.play_circle_fill,
    this.videoOverlayColor = AppColors.white,
    this.padding = EdgeInsets.zero,
    this.scrollPhysics,
  });

  final double itemSize;
  final double spacing;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final IconData addButtonIcon;
  final IconData removeButtonIcon;
  final Color removeButtonColor;
  final Color removeButtonBackgroundColor;
  final IconData videoOverlayIcon;
  final Color videoOverlayColor;
  final EdgeInsets padding;
  final ScrollPhysics? scrollPhysics;
}
