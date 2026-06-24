import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Настройки стандартного AppBar. Для нестандартного — [AppPageAppBarBuilder] или `appBar`.
class AppPageAppBarConfig {
  const AppPageAppBarConfig({
    this.title,
    this.titleWidget,
    this.needBuildAppBar = true,
    this.leadingWidget,
    this.actionsWidget,
    this.bottomWidget,
    this.canPop,
    this.showBackButton,
    this.onBackPressed,
    this.backgroundColor = AppColors.appBarBackground,
    this.shapeWidget,
    this.bottomBorderRadius = 0,
    this.bottomBorderColor,
  });

  final String? title;
  final Widget? titleWidget;
  final bool needBuildAppBar;
  final Widget? leadingWidget;
  final List<Widget>? actionsWidget;
  final PreferredSizeWidget? bottomWidget;
  final bool? canPop;
  final bool? showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final ShapeBorder? shapeWidget;
  final double bottomBorderRadius;
  final Color? bottomBorderColor;
}

/// Контекст для [AppPageAppBarBuilder] — навигация и back-кнопка.
class AppPageAppBarLayout {
  const AppPageAppBarLayout({
    required this.showBackButton,
    required this.canPop,
    required this.onBackPressed,
  });

  final bool showBackButton;
  final bool canPop;
  final VoidCallback onBackPressed;
}

typedef AppPageAppBarBuilder =
    PreferredSizeWidget? Function(
      BuildContext context,
      AppPageAppBarLayout layout,
    );

/// Обёртки body: SafeArea, padding, dismiss keyboard.
class AppPageBodyConfig {
  const AppPageBodyConfig({
    this.safeArea = true,
    this.padding,
    this.dismissKeyboardOnTap = true,
  });

  final bool safeArea;
  final EdgeInsetsGeometry? padding;
  final bool dismissKeyboardOnTap;
}
