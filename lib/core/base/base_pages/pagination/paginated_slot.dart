import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Слот для scroll-header/footer в [PaginatedListView] / [PaginatedGridView].
class PaginatedScrollSlot extends StatelessWidget {
  const PaginatedScrollSlot({
    required this.child,
    super.key,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(ThemeBuilder.defaultPadding),
      child: child,
    );
  }
}

/// Слот для fixed header/footer в [PaginatedListFrame].
class PaginatedFixedSlot extends StatelessWidget {
  const PaginatedFixedSlot({
    required this.child,
    super.key,
    this.padding,
    this.backgroundColor,
    this.showTopDivider = false,
    this.showBottomDivider = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final bool showTopDivider;
  final bool showBottomDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.surfaceColor,
        border: Border(
          top: showTopDivider
              ? const BorderSide(color: AppColors.divider)
              : BorderSide.none,
          bottom: showBottomDivider
              ? const BorderSide(color: AppColors.divider)
              : BorderSide.none,
        ),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(ThemeBuilder.defaultPadding),
        child: child,
      ),
    );
  }
}
