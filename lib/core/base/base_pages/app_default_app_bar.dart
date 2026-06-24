import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold_config.dart';
import 'package:base_flutter_proj/core/components/app_bar_bottom_border_shape.dart';
import 'package:base_flutter_proj/core/components/custom_back_button.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

/// Стандартный AppBar проекта. Используется в [AppPageScaffold] по умолчанию.
class AppDefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppDefaultAppBar({
    required this.config,
    required this.showBackButton,
    required this.onBackPressed,
    super.key,
  });

  final AppPageAppBarConfig config;
  final bool showBackButton;
  final VoidCallback onBackPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: config.backgroundColor,
      title: config.titleWidget ?? _buildTitle(),
      leading: config.leadingWidget ?? _buildLeading(),
      actions: config.actionsWidget,
      bottom: config.bottomWidget,
      shape:
          config.shapeWidget ??
          AppBarBottomBorderShape(
            radius: config.bottomBorderRadius,
            borderColor: config.bottomBorderColor ?? config.backgroundColor,
          ),
    );
  }

  Widget? _buildTitle() {
    final title = config.title;
    if (title == null) {
      return null;
    }
    return AutoSizeText(
      title,
      maxLines: 2,
      style: const TextStyle(color: AppColors.white),
    );
  }

  Widget? _buildLeading() {
    if (!showBackButton) {
      return null;
    }
    return CustomBackButton(onPressed: onBackPressed);
  }
}
