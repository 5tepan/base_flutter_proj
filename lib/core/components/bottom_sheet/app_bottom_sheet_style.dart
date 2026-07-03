import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Визуальные настройки [AppBottomSheetPanel].
class AppBottomSheetStyle {
  const AppBottomSheetStyle({
    this.backgroundColor = AppColors.white,
    this.borderRadius = const BorderRadius.vertical(top: Radius.circular(16)),
    this.contentPadding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.headerPadding = const EdgeInsets.fromLTRB(16, 4, 4, 0),
    this.barrierColor = const Color(0x99000000),
    this.showDragHandle = true,
    this.dragHandle,
    this.dragHandleWidth = 40,
    this.dragHandleHeight = 4,
    this.dragHandleColor = AppColors.midGrey,
    this.dragHandlePadding = const EdgeInsets.symmetric(vertical: 12),
    this.titleStyle,
    this.showHeaderDivider = false,
    this.headerDividerColor = AppColors.divider,
    this.closeIcon = Icons.close,
    this.closeIconColor = AppColors.darkGrey,
    this.closeButtonTooltip,
    this.gapAfterHeader = 12,
    this.gapAfterDragHandle = 0,
  });

  final Color backgroundColor;
  final BorderRadius borderRadius;
  final EdgeInsets contentPadding;
  final EdgeInsets headerPadding;
  final Color barrierColor;
  final bool showDragHandle;
  final Widget? dragHandle;
  final double dragHandleWidth;
  final double dragHandleHeight;
  final Color dragHandleColor;
  final EdgeInsets dragHandlePadding;
  final TextStyle? titleStyle;
  final bool showHeaderDivider;
  final Color headerDividerColor;
  final IconData closeIcon;
  final Color closeIconColor;
  final String? closeButtonTooltip;
  final double gapAfterHeader;
  final double gapAfterDragHandle;

  TextStyle titleStyleOrDefault(BuildContext context) {
    return titleStyle ??
        AppTextStyle.title.copyWith(
          color: AppColors.onSecondaryColor,
          fontWeight: FontWeight.w600,
        );
  }

  AppBottomSheetStyle copyWith({
    Color? backgroundColor,
    BorderRadius? borderRadius,
    EdgeInsets? contentPadding,
    EdgeInsets? headerPadding,
    Color? barrierColor,
    bool? showDragHandle,
    Widget? dragHandle,
    double? dragHandleWidth,
    double? dragHandleHeight,
    Color? dragHandleColor,
    EdgeInsets? dragHandlePadding,
    TextStyle? titleStyle,
    bool? showHeaderDivider,
    Color? headerDividerColor,
    IconData? closeIcon,
    Color? closeIconColor,
    String? closeButtonTooltip,
    double? gapAfterHeader,
    double? gapAfterDragHandle,
  }) {
    return AppBottomSheetStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      barrierColor: barrierColor ?? this.barrierColor,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      dragHandle: dragHandle ?? this.dragHandle,
      dragHandleWidth: dragHandleWidth ?? this.dragHandleWidth,
      dragHandleHeight: dragHandleHeight ?? this.dragHandleHeight,
      dragHandleColor: dragHandleColor ?? this.dragHandleColor,
      dragHandlePadding: dragHandlePadding ?? this.dragHandlePadding,
      titleStyle: titleStyle ?? this.titleStyle,
      showHeaderDivider: showHeaderDivider ?? this.showHeaderDivider,
      headerDividerColor: headerDividerColor ?? this.headerDividerColor,
      closeIcon: closeIcon ?? this.closeIcon,
      closeIconColor: closeIconColor ?? this.closeIconColor,
      closeButtonTooltip: closeButtonTooltip ?? this.closeButtonTooltip,
      gapAfterHeader: gapAfterHeader ?? this.gapAfterHeader,
      gapAfterDragHandle: gapAfterDragHandle ?? this.gapAfterDragHandle,
    );
  }
}
