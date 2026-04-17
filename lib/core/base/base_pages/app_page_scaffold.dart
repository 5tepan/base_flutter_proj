import 'package:base_flutter_proj/core/components/app_bar_bottom_border_shape.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/components/custom_back_button.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

class AppPageAppBarConfig {
  final String? title;
  final Widget? titleWidget;
  final bool needBuildAppBar;
  final Widget? leadingWidget;
  final List<Widget>? actionsWidget;
  final PreferredSizeWidget? bottomWidget;
  final bool? canPop;
  final bool? showBackButton;
  final VoidCallback? onBackPressed;
  final Color backgroundColor;
  final ShapeBorder? shapeWidget;
  final double bottomBorderRadius;
  final Color? bottomBorderColor;

  const AppPageAppBarConfig({
    this.title,
    this.titleWidget,
    this.needBuildAppBar = true,
    this.leadingWidget,
    this.actionsWidget,
    this.bottomWidget,
    this.canPop,
    this.showBackButton,
    this.onBackPressed,
    this.backgroundColor = AppColors.appBarBackground,
    this.shapeWidget,
    this.bottomBorderRadius = 0,
    this.bottomBorderColor,
  });
}

class AppPageBodyConfig {
  final bool safeArea;
  final EdgeInsetsGeometry? padding;
  final bool dismissKeyboardOnTap;

  const AppPageBodyConfig({
    this.safeArea = true,
    this.padding,
    this.dismissKeyboardOnTap = true,
  });
}

class AppPageScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final AppPageAppBarConfig appBarConfig;
  final AppPageBodyConfig bodyConfig;
  final bool isLoading;
  final Color loadingOverlayColor;
  final Widget? loadingWidget;

  const AppPageScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.backgroundColor = AppColors.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.systemUiOverlayStyle,
    this.appBarConfig = const AppPageAppBarConfig(),
    this.bodyConfig = const AppPageBodyConfig(),
    this.isLoading = false,
    this.loadingOverlayColor = AppColors.white,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final routeCanPop = ModalRoute.of(context)?.canPop ?? false;
    final navigatorCanPop = Navigator.of(context).canPop();
    final effectiveCanPop = appBarConfig.canPop ?? navigatorCanPop;
    final shouldShowBack =
        appBarConfig.showBackButton ?? (routeCanPop && navigatorCanPop);
    Widget content = body;

    if (bodyConfig.padding != null) {
      content = Padding(padding: bodyConfig.padding!, child: content);
    }

    if (bodyConfig.safeArea) {
      content = SafeArea(child: content);
    }

    if (bodyConfig.dismissKeyboardOnTap) {
      content = GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: content,
      );
    }

    if (isLoading) {
      content = Stack(
        children: [
          content,
          ColoredBox(
            color: loadingOverlayColor,
            child: Center(child: loadingWidget ?? const AppLoadingIndicator()),
          ),
        ],
      );
    }

    return PopScope(
      canPop: effectiveCanPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle ?? ThemeBuilder.systemUiOverlayStyle,
        child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          appBar: appBarConfig.needBuildAppBar
              ? (appBar ?? buildAppBar(context, shouldShowBack))
              : null,
          body: content,
        ),
      ),
    );
  }

  PreferredSizeWidget? buildAppBar(BuildContext context, bool shouldShowBack) {
    return AppBar(
      backgroundColor: appBarConfig.backgroundColor,
      title: appBarConfig.titleWidget ?? buildAppBarTitle(),
      leading:
          appBarConfig.leadingWidget ??
          buildAppBarLeading(context, shouldShowBack),
      actions: appBarConfig.actionsWidget,
      bottom: appBarConfig.bottomWidget,
      shape:
          appBarConfig.shapeWidget ??
          AppBarBottomBorderShape(
            radius: appBarConfig.bottomBorderRadius,
            borderColor:
                appBarConfig.bottomBorderColor ?? appBarConfig.backgroundColor,
          ),
    );
  }

  Widget? buildAppBarTitle() {
    final title = appBarConfig.title;
    if (title == null) {
      return null;
    }
    return AutoSizeText(
      title,
      maxLines: 2,
      style: const TextStyle(color: AppColors.white),
    );
  }

  Widget? buildAppBarLeading(BuildContext context, bool shouldShowBack) {
    return shouldShowBack
        ? CustomBackButton(
            onPressed:
                appBarConfig.onBackPressed ?? () => Navigator.maybePop(context),
          )
        : null;
  }
}
