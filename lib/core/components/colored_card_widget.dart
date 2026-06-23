import 'package:base_flutter_proj/core/components/card_widget.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

class ColoredCardWidget extends StatelessWidget {
  final Widget? child;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double? width;
  final double? height;

  final Color glowColor;
  final double glowSize;
  final Offset glowOffset;
  final double glowOpacity;

  final bool showShadow;
  final List<BoxShadow>? customShadow;

  const ColoredCardWidget({
    super.key,
    this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = EdgeInsets.zero,
    this.glowColor = AppColors.primaryColor,
    this.glowSize = 420,
    this.glowOffset = const Offset(-160, -220),
    this.glowOpacity = 1,
    this.customShadow,
    this.showShadow = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      margin: margin,
      width: width,
      height: height,
      cardShadow:
          customShadow ?? (showShadow ? AppShadows.defaultCardShadow : null),
      child: Stack(
        children: [
          Positioned(
            left: glowOffset.dx,
            top: glowOffset.dy,
            child: IgnorePointer(
              child: Container(
                width: glowSize,
                height: glowSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      glowColor.withValues(alpha: glowOpacity),
                      glowColor.withValues(alpha: glowOpacity * 0.75),
                      glowColor.withValues(alpha: glowOpacity * 0.45),
                      glowColor.withValues(alpha: glowOpacity * 0.18),
                      glowColor.withValues(alpha: 0),
                    ],
                    stops: const [0.0, 0.22, 0.48, 0.72, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: padding, child: child),
        ],
      ),
    );
  }
}
