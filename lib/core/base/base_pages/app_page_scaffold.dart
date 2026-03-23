import 'package:base_flutter_proj/core/components/custom_back_button.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

class AppPageScaffold extends StatelessWidget {
  final String? title;
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool safeArea;
  final EdgeInsetsGeometry? padding;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final List<Widget>? appBarActions;
  final PreferredSizeWidget? appBarBottom;
  final Widget? appBarLeading;
  final bool dismissKeyboardOnTap;
  final bool? canPop;
  final VoidCallback? onBackPressed;
  final bool? showBackButton;

  const AppPageScaffold({
    required this.body,
    super.key,
    this.title,
    this.appBar,
    this.backgroundColor = AppColors.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.safeArea = true,
    this.padding,
    this.systemUiOverlayStyle,
    this.appBarActions,
    this.appBarBottom,
    this.appBarLeading,
    this.dismissKeyboardOnTap = true,
    this.canPop,
    this.onBackPressed,
    this.showBackButton,
  });

  @override
  Widget build(BuildContext context) {
    final navigatorCanPop = Navigator.of(context).canPop();
    final effectiveCanPop = canPop ?? navigatorCanPop;
    final shouldShowBack = showBackButton ?? effectiveCanPop;
    Widget content = body;

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    if (safeArea) {
      content = SafeArea(child: content);
    }

    if (dismissKeyboardOnTap) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: content,
      );
    }

    return PopScope(
      canPop: effectiveCanPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle ?? ThemeBuilder.systemUiOverlayStyle,
        child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: appBar ?? buildAppBar(context, shouldShowBack),
          body: content,
        ),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context, bool shouldShowBack) {
    return AppBar(
      title: buildAppBarTitle(context),
      leading: appBarLeading ?? buildAppBarLeading(context, shouldShowBack),
      actions: appBarActions,
      bottom: appBarBottom,
    );
  }

  Widget? buildAppBarTitle(BuildContext context) {
    if (title == null) {
      return null;
    }
    return AutoSizeText(
      title!,
      maxLines: 2,
      style: const TextStyle(color: AppColors.white),
    );
  }

  Widget? buildAppBarLeading(BuildContext context, bool shouldShowBack) {
    return shouldShowBack
        ? CustomBackButton(
            onPressed: onBackPressed ?? () => Navigator.maybePop(context),
          )
        : null;
  }
}
