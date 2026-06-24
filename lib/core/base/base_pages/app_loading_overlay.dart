import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Блокирующий loading-overlay поверх [child].
///
/// Можно использовать отдельно, если body не обёрнут в [AppPageScaffold].
class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    required this.child,
    required this.isLoading,
    this.overlayColor = AppColors.white,
    this.loadingWidget,
    super.key,
  });

  final Widget child;
  final bool isLoading;
  final Color overlayColor;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    return Stack(
      children: [
        child,
        ColoredBox(
          color: overlayColor,
          child: Center(child: loadingWidget ?? const AppLoadingIndicator()),
        ),
      ],
    );
  }
}
