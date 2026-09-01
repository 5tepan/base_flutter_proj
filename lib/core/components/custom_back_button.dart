import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/assets/app_icon.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key, this.color, this.onPressed});

  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: IconButton(
        icon: AppIcon(
          AppAssets.arrowBack,
          color: color ?? AppColors.white,
        ),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: onPressed ?? () => context.pop(),
      ),
    );
  }
}
