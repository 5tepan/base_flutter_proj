import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/base_error_widget.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:flutter/material.dart';

/// Полноэкранная ошибка на [AppPageScaffold] + [BaseErrorWidget].
class AppErrorPage extends StatelessWidget {
  const AppErrorPage({
    required this.errorCode,
    required this.onRetry,
    super.key,
    this.serverMessage,
    this.showLogo = true,
  });

  final AppErrorCode errorCode;
  final String? serverMessage;
  final VoidCallback onRetry;
  final bool showLogo;

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      appBarConfig: const AppPageAppBarConfig(needBuildAppBar: false),
      bodyConfig: const AppPageBodyConfig(
        padding: ScreenContentInsets.zero,
        dismissKeyboardOnTap: false,
      ),
      body: Column(
        children: [
          if (showLogo)
            Expanded(
              flex: 4,
              child: Center(
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).width * 0.6,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipOval(
                      child: Image.asset(AssetsCatalog.logo),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: ScreenContentInsets.horizontal,
              child: BaseErrorWidget.fromError(
                context: context,
                errorCode: errorCode,
                serverMessage: serverMessage,
                onPressedButton: onRetry,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
