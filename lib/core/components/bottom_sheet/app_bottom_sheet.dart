import 'package:base_flutter_proj/core/components/bottom_sheet/app_bottom_sheet_panel.dart';
import 'package:base_flutter_proj/core/components/bottom_sheet/app_bottom_sheet_style.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

typedef AppBottomSheetBuilder = Widget Function(BuildContext sheetContext);

/// Универсальный bottom sheet на базе [modal_bottom_sheet].
///
/// Поддерживает drag-to-close, tap outside, заголовок, handle, close icon.
class AppBottomSheet {
  const AppBottomSheet._();

  /// Material modal (Android / cross-platform).
  static Future<T?> show<T>({
    required BuildContext context,
    required AppBottomSheetBuilder builder,
    String? title,
    Widget? titleWidget,
    AppBottomSheetStyle style = const AppBottomSheetStyle(),
    bool showCloseButton = true,
    Widget? headerActions,
    Widget? header,
    Widget? footer,
    bool expand = false,
    bool scrollable = false,
    bool safeAreaBottom = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool bounce = false,
    bool useRootNavigator = false,
    Duration? duration,
    RouteSettings? settings,
  }) {
    assert(
      title == null || titleWidget == null,
      'Задайте либо title, либо titleWidget.',
    );

    return showMaterialModalBottomSheet<T>(
      context: context,
      expand: expand,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      bounce: bounce,
      useRootNavigator: useRootNavigator,
      duration: duration,
      settings: settings,
      backgroundColor: Colors.transparent,
      barrierColor: style.barrierColor,
      shape: RoundedRectangleBorder(borderRadius: style.borderRadius),
      builder: (sheetContext) {
        return AppBottomSheetPanel(
          title: title,
          titleWidget: titleWidget,
          style: style,
          showCloseButton: showCloseButton,
          onClose: () => Navigator.of(sheetContext).pop(),
          headerActions: headerActions,
          header: header,
          footer: footer,
          expand: expand,
          scrollable: scrollable,
          safeAreaBottom: safeAreaBottom,
          child: builder(sheetContext),
        );
      },
    );
  }

  /// Упрощённый вызов: только контент без builder.
  static Future<T?> showContent<T>({
    required BuildContext context,
    required Widget content,
    String? title,
    Widget? titleWidget,
    AppBottomSheetStyle style = const AppBottomSheetStyle(),
    bool showCloseButton = true,
    Widget? headerActions,
    Widget? footer,
    bool expand = false,
    bool scrollable = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool useRootNavigator = false,
  }) {
    return show<T>(
      context: context,
      title: title,
      titleWidget: titleWidget,
      style: style,
      showCloseButton: showCloseButton,
      headerActions: headerActions,
      footer: footer,
      expand: expand,
      scrollable: scrollable,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useRootNavigator: useRootNavigator,
      builder: (_) => content,
    );
  }

  /// Cupertino modal (iOS-стиль).
  static Future<T?> showCupertino<T>({
    required BuildContext context,
    required AppBottomSheetBuilder builder,
    String? title,
    Widget? titleWidget,
    AppBottomSheetStyle style = const AppBottomSheetStyle(),
    bool showCloseButton = true,
    Widget? headerActions,
    Widget? header,
    Widget? footer,
    bool expand = false,
    bool scrollable = false,
    bool safeAreaBottom = true,
    bool isDismissible = true,
    bool enableDrag = true,
    bool bounce = true,
    bool useRootNavigator = false,
    Duration? duration,
    RouteSettings? settings,
  }) {
    assert(
      title == null || titleWidget == null,
      'Задайте либо title, либо titleWidget.',
    );

    return showCupertinoModalBottomSheet<T>(
      context: context,
      expand: expand,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      bounce: bounce,
      useRootNavigator: useRootNavigator,
      duration: duration,
      settings: settings,
      backgroundColor: Colors.transparent,
      barrierColor: style.barrierColor,
      builder: (sheetContext) {
        return AppBottomSheetPanel(
          title: title,
          titleWidget: titleWidget,
          style: style,
          showCloseButton: showCloseButton,
          onClose: () => Navigator.of(sheetContext).pop(),
          headerActions: headerActions,
          header: header,
          footer: footer,
          expand: expand,
          scrollable: scrollable,
          safeAreaBottom: safeAreaBottom,
          child: builder(sheetContext),
        );
      },
    );
  }

  /// Bar modal (handle встроен в контейнер пакета + [AppBottomSheetPanel]).
  static Future<T?> showBar<T>({
    required BuildContext context,
    required AppBottomSheetBuilder builder,
    String? title,
    Widget? titleWidget,
    AppBottomSheetStyle style = const AppBottomSheetStyle(),
    bool showCloseButton = true,
    Widget? headerActions,
    Widget? footer,
    bool expand = false,
    bool scrollable = false,
    bool isDismissible = true,
    bool enableDrag = true,
    bool bounce = true,
    bool useRootNavigator = false,
    Widget? topControl,
  }) {
    final panelStyle = style.showDragHandle
        ? style.copyWith(showDragHandle: false)
        : style;

    return showBarModalBottomSheet<T>(
      context: context,
      expand: expand,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      bounce: bounce,
      useRootNavigator: useRootNavigator,
      backgroundColor: Colors.transparent,
      barrierColor: style.barrierColor,
      topControl: topControl ?? _defaultBarTopControl(panelStyle),
      shape: RoundedRectangleBorder(borderRadius: style.borderRadius),
      builder: (sheetContext) {
        return AppBottomSheetPanel(
          title: title,
          titleWidget: titleWidget,
          style: panelStyle,
          showCloseButton: showCloseButton,
          onClose: () => Navigator.of(sheetContext).pop(),
          headerActions: headerActions,
          footer: footer,
          expand: expand,
          scrollable: scrollable,
          child: builder(sheetContext),
        );
      },
    );
  }

  static Widget _defaultBarTopControl(AppBottomSheetStyle style) {
    final customHandle = style.dragHandle;
    if (customHandle != null) {
      return Padding(
        padding: style.dragHandlePadding,
        child: Center(child: customHandle),
      );
    }

    return Padding(
      padding: style.dragHandlePadding,
      child: Center(
        child: Container(
          width: style.dragHandleWidth,
          height: style.dragHandleHeight,
          decoration: BoxDecoration(
            color: style.dragHandleColor,
            borderRadius: BorderRadius.circular(style.dragHandleHeight),
          ),
        ),
      ),
    );
  }
}
