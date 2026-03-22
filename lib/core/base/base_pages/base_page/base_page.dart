import 'package:base_flutter_proj/core/base/base_pages/base_page/base_page_provider.dart';
import 'package:base_flutter_proj/core/base/base_pages/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/base/base_pages/components/base_error_widget.dart';
import 'package:base_flutter_proj/core/base/base_pages/components/keyboard_dismisser.dart';
import 'package:base_flutter_proj/core/base/base_pages/services/toast_service.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class BasePage extends ConsumerStatefulWidget {
  final String? title;

  const BasePage({super.key, this.title});

  @override
  BasePageState createState();
}

abstract class BasePageState<T extends BasePage> extends ConsumerState<T> {
  StackFit bodyFit = StackFit.expand;
  bool isSafeAreaEnabled = false;
  SystemUiOverlayStyle get systemUiOverlayStyle =>
      ThemeBuilder.systemUiOverlayStyle;

  /// --- LIFECYCLE ---

  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {}

  /// --- PROVIDERS ---

  LoadingState get loading => ref.watch(loadingProvider);
  ToastService get toast => ref.read(toastServiceProvider);

  /// --- BUILD ---

  @override
  Widget build(BuildContext context) {
    Widget body = buildBody(context, ref);
    body = decorateBody(context, body);
    if (isSafeAreaEnabled) {
      body = SafeArea(child: body);
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiOverlayStyle,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: body,
        floatingActionButton: buildFloatingActionButton(context),
      ),
    );
  }

  /// --- UI ---

  PreferredSizeWidget? buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: AppPlatform.isIOS,
      title: buildAppBarTitle(context),
    );
  }

  Widget? buildAppBarTitle(BuildContext context) {
    if (widget.title == null) return null;

    return AutoSizeText(
      widget.title!,
      maxLines: 2,
      style: const TextStyle(color: AppColors.white),
    );
  }

  Widget decorateBody(BuildContext context, Widget body) {
    return Stack(
      fit: bodyFit,
      children: [
        if (!loading.isLoading || !loading.hideContent) body,
        if (loading.isLoading) buildLoadingIndicator(),
      ],
    );
  }

  Widget buildLoadingIndicator() {
    return const AppLoadingIndicator();
  }

  Widget buildBaseError({required VoidCallback onPressedButton}) {
    return BaseErrorWidget(onPressedButton: onPressedButton);
  }

  Widget decorateKeyboardUnfocusing(Widget child) {
    return KeyboardDismisser(child: child);
  }

  Widget? buildFloatingActionButton(BuildContext context) => null;

  /// --- ABSTRACT ---

  Widget buildBody(BuildContext context, WidgetRef ref);

  /// --- ACTIONS ---

  void showMessage([String? message]) {
    toast.showMessage(message);
  }

  void showError([String? message]) {
    toast.showError(message);
  }

  void showLoading({bool hideContent = false}) {
    ref.read(loadingProvider.notifier).show(hideContent: hideContent);
  }

  void hideLoading() {
    ref.read(loadingProvider.notifier).hide();
  }
}
