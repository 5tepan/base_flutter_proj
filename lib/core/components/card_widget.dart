import 'package:base_flutter_proj/core/providers/theme_provider.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardWidget extends ConsumerWidget {
  final Widget? child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color color;
  final double? width;
  final double? height;
  final List<BoxShadow>? cardShadow;

  const CardWidget({
    super.key,
    this.child,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.color = AppColors.surfaceColor,
    this.width,
    this.height,
    this.cardShadow,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeBuilder = ref.read(themeBuilderProvider);
    final cardDecoration = themeBuilder
        .buildCardDecoration(context)
        .copyWith(color: color, boxShadow: cardShadow);
    return Container(
      width: width,
      height: height,
      decoration: cardDecoration,
      margin: margin,
      padding: padding,
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
