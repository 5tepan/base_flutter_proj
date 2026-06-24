import 'package:base_flutter_proj/core/base/base_pages/app_default_app_bar.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_loading_overlay.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_body.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold_config.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'app_default_app_bar.dart';
export 'app_loading_overlay.dart';
export 'app_page_body.dart';
export 'app_page_scaffold_config.dart';

/// Универсальный каркас страницы: Scaffold + стандартные обёртки body.
///
/// Приоритет AppBar:
/// 1. `appBarConfig.needBuildAppBar == false` → без AppBar
/// 2. [appBar] — готовый виджет
/// 3. [appBarBuilder] — кастомная сборка с [AppPageAppBarLayout]
/// 4. [AppDefaultAppBar] из [appBarConfig]
///
/// Сложные layout (SliverAppBar, карта на весь экран) — чистый [Scaffold]
/// + [AppPageBody] / [AppLoadingOverlay] по необходимости.
class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.appBarBuilder,
    this.appBarConfig = const AppPageAppBarConfig(),
    this.bodyConfig = const AppPageBodyConfig(),
    this.backgroundColor = AppColors.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.systemUiOverlayStyle,
    this.isLoading = false,
    this.loadingOverlayColor = AppColors.white,
    this.loadingWidget,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerEnableOpenDragGesture,
    this.endDrawerEnableOpenDragGesture,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final AppPageAppBarBuilder? appBarBuilder;
  final AppPageAppBarConfig appBarConfig;
  final AppPageBodyConfig bodyConfig;
  final Color backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final SystemUiOverlayStyle? systemUiOverlayStyle;
  final bool isLoading;
  final Color loadingOverlayColor;
  final Widget? loadingWidget;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool? drawerEnableOpenDragGesture;
  final bool? endDrawerEnableOpenDragGesture;

  @override
  Widget build(BuildContext context) {
    final navigatorCanPop = Navigator.of(context).canPop();
    final routeCanPop = ModalRoute.of(context)?.canPop ?? false;
    final effectiveCanPop = appBarConfig.canPop ?? navigatorCanPop;
    final shouldShowBack =
        appBarConfig.showBackButton ?? (routeCanPop && navigatorCanPop);
    final onBackPressed =
        appBarConfig.onBackPressed ?? () => Navigator.maybePop(context);
    final appBarLayout = AppPageAppBarLayout(
      showBackButton: shouldShowBack,
      canPop: effectiveCanPop,
      onBackPressed: onBackPressed,
    );

    final content = AppLoadingOverlay(
      isLoading: isLoading,
      overlayColor: loadingOverlayColor,
      loadingWidget: loadingWidget,
      child: AppPageBody(config: bodyConfig, child: body),
    );

    return PopScope(
      canPop: effectiveCanPop,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle ?? ThemeBuilder.systemUiOverlayStyle,
        child: Scaffold(
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          extendBody: extendBody,
          extendBodyBehindAppBar: extendBodyBehindAppBar,
          appBar: _resolveAppBar(context, appBarLayout),
          body: content,
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
          bottomNavigationBar: bottomNavigationBar,
          bottomSheet: bottomSheet,
          persistentFooterButtons: persistentFooterButtons,
          drawer: drawer,
          endDrawer: endDrawer,
          drawerEnableOpenDragGesture: drawerEnableOpenDragGesture ?? true,
          endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture ?? true,
        ),
      ),
    );
  }

  PreferredSizeWidget? _resolveAppBar(
    BuildContext context,
    AppPageAppBarLayout layout,
  ) {
    if (!appBarConfig.needBuildAppBar) {
      return null;
    }
    if (appBar != null) {
      return appBar;
    }
    if (appBarBuilder != null) {
      return appBarBuilder!(context, layout);
    }
    return AppDefaultAppBar(
      config: appBarConfig,
      showBackButton: layout.showBackButton,
      onBackPressed: layout.onBackPressed,
    );
  }
}
