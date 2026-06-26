import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold_config.dart';
import 'package:flutter/material.dart';

/// Обёртка body: padding → SafeArea → dismiss keyboard.
///
/// Отступы контента задаются в [AppPageBodyConfig.padding] на [AppPageScaffold].
/// Можно использовать отдельно на сложных экранах без [AppPageScaffold].
class AppPageBody extends StatelessWidget {
  const AppPageBody({
    required this.child,
    this.config = const AppPageBodyConfig(),
    super.key,
  });

  final Widget child;
  final AppPageBodyConfig config;

  @override
  Widget build(BuildContext context) {
    var content = child;

    if (config.padding != EdgeInsets.zero) {
      content = Padding(padding: config.padding, child: content);
    }

    if (config.safeArea) {
      content = SafeArea(child: content);
    }

    if (config.dismissKeyboardOnTap) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: content,
      );
    }

    return content;
  }
}
