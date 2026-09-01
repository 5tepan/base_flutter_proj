import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/assets/app_icon.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Экран-заглушка «В разработке».
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, this.onTap});

  final VoidCallback? onTap;

  static const _backgroundColor = Color(0xFF7A8AFF);

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      backgroundColor: _backgroundColor,
      appBarConfig: AppPageAppBarConfig(
        title: S.of(context).inDevelopment,
        backgroundColor: _backgroundColor,
        actionsWidget: [
          IconButton(
            icon: const AppIcon(AppAssets.logout, color: AppColors.white),
            onPressed: onTap,
          ),
        ],
      ),
      bodyConfig: const AppPageBodyConfig(
        padding: ScreenContentInsets.zero,
        safeArea: false,
        dismissKeyboardOnTap: false,
      ),
      body: Center(
        child: AppIcon(
          AppAssets.inDevelopment,
          size: 280,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
