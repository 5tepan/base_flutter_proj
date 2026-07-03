import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

typedef UniversalModalPressed = void Function(BuildContext modalContext);

/// Модальное окно с заголовком, контентом и одной или двумя кнопками действий.
class UniversalModal extends StatelessWidget {
  const UniversalModal({
    required this.content,
    required this.primaryLabel,
    super.key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.onPrimaryPressed,
    this.secondaryLabel,
    this.onSecondaryPressed,
    this.padding = const EdgeInsets.all(16),
    this.maxWidth = 320,
    this.backgroundColor = AppColors.white,
    this.borderRadius = 20,
    this.primaryButtonStyle,
    this.secondaryButtonStyle,
    this.showCloseIcon = false,
    this.onClosePressed,
    this.showBorder = false,
    this.bodyCentered = true,
    this.bodyTextStyle,
    this.primaryButtonTextStyle,
    this.secondaryButtonTextStyle,
    this.primaryButtonHeight = 46,
    this.secondaryButtonHeight,
    this.spacingBeforePrimaryButton = 16,
    this.spacingBetweenButtons = 8,
  }) : assert(
         title == null || titleWidget == null,
         'Задайте либо title, либо titleWidget, не оба сразу.',
       );

  // --- Контент ---

  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final Widget content;
  final TextStyle? bodyTextStyle;
  final bool bodyCentered;

  // --- Действия ---

  final String primaryLabel;
  final UniversalModalPressed? onPrimaryPressed;
  final String? secondaryLabel;
  final UniversalModalPressed? onSecondaryPressed;
  final UniversalModalPressed? onClosePressed;

  // --- Внешний вид ---

  final EdgeInsets padding;
  final double maxWidth;
  final Color backgroundColor;
  final double borderRadius;
  final bool showBorder;
  final bool showCloseIcon;

  // --- Кнопки ---

  final ButtonStyle? primaryButtonStyle;
  final ButtonStyle? secondaryButtonStyle;
  final TextStyle? primaryButtonTextStyle;
  final TextStyle? secondaryButtonTextStyle;
  final double primaryButtonHeight;
  final double? secondaryButtonHeight;
  final double spacingBeforePrimaryButton;
  final double spacingBetweenButtons;

  static Future<T?> showText<T>({
    required BuildContext context,
    required String body,
    required String primaryLabel,
    UniversalModalPressed? onPrimaryPressed,
    TextStyle? bodyStyle,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    EdgeInsets padding = const EdgeInsets.all(16),
    double maxWidth = 320,
    Color backgroundColor = AppColors.white,
    double borderRadius = 20,
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? secondaryButtonStyle,
    TextStyle? primaryButtonTextStyle,
    TextStyle? secondaryButtonTextStyle,
    double primaryButtonHeight = 46,
    double? secondaryButtonHeight,
    String? secondaryLabel,
    UniversalModalPressed? onSecondaryPressed,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool showBorder = false,
    double spacingBeforePrimaryButton = 16,
    double spacingBetweenButtons = 8,
  }) {
    final effectiveBodyStyle =
        bodyStyle ??
        AppTextStyle.body2.copyWith(color: AppColors.black, height: 1.28);

    return show<T>(
      context: context,
      content: Text(
        body,
        style: effectiveBodyStyle,
        textAlign: TextAlign.center,
      ),
      primaryLabel: primaryLabel,
      onPrimaryPressed: onPrimaryPressed,
      secondaryLabel: secondaryLabel,
      onSecondaryPressed: onSecondaryPressed,
      title: title,
      titleWidget: titleWidget,
      titleStyle: titleStyle,
      padding: padding,
      maxWidth: maxWidth,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      primaryButtonStyle: primaryButtonStyle,
      secondaryButtonStyle: secondaryButtonStyle,
      primaryButtonTextStyle: primaryButtonTextStyle,
      secondaryButtonTextStyle: secondaryButtonTextStyle,
      primaryButtonHeight: primaryButtonHeight,
      secondaryButtonHeight: secondaryButtonHeight,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      showBorder: showBorder,
      bodyTextStyle: effectiveBodyStyle,
      spacingBeforePrimaryButton: spacingBeforePrimaryButton,
      spacingBetweenButtons: spacingBetweenButtons,
    );
  }

  /// Диалог подтверждения с двумя кнопками. Возвращает `true`, если нажата primary.
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String body,
    String? title,
    String? primaryLabel,
    String? secondaryLabel,
    bool barrierDismissible = true,
  }) async {
    final l10n = S.of(context);
    final result = await showText<bool>(
      context: context,
      title: title,
      body: body,
      primaryLabel: primaryLabel ?? l10n.universalModalYes,
      secondaryLabel: secondaryLabel ?? l10n.universalModalNo,
      barrierDismissible: barrierDismissible,
      onPrimaryPressed: (modalContext) => Navigator.of(modalContext).pop(true),
      onSecondaryPressed: (modalContext) =>
          Navigator.of(modalContext).pop(false),
    );
    return result ?? false;
  }

  /// Информационный диалог с одной кнопкой.
  static Future<void> showAlert({
    required BuildContext context,
    required String body,
    String? title,
    String? primaryLabel,
    bool barrierDismissible = true,
  }) {
    final l10n = S.of(context);
    return showText<void>(
      context: context,
      title: title,
      body: body,
      primaryLabel: primaryLabel ?? l10n.universalModalOk,
      barrierDismissible: barrierDismissible,
    );
  }

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    required String primaryLabel,
    UniversalModalPressed? onPrimaryPressed,
    String? title,
    Widget? titleWidget,
    TextStyle? titleStyle,
    String? secondaryLabel,
    UniversalModalPressed? onSecondaryPressed,
    EdgeInsets padding = const EdgeInsets.fromLTRB(24, 32, 24, 28),
    double maxWidth = 320,
    Color backgroundColor = AppColors.white,
    double borderRadius = 32,
    ButtonStyle? primaryButtonStyle,
    ButtonStyle? secondaryButtonStyle,
    TextStyle? primaryButtonTextStyle,
    TextStyle? secondaryButtonTextStyle,
    double primaryButtonHeight = 46,
    double? secondaryButtonHeight,
    bool showCloseIcon = false,
    UniversalModalPressed? onClosePressed,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool showBorder = false,
    bool bodyCentered = true,
    TextStyle? bodyTextStyle,
    double spacingBeforePrimaryButton = 16,
    double spacingBetweenButtons = 8,
  }) {
    return _presentDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      child: UniversalModal(
        title: title,
        titleWidget: titleWidget,
        titleStyle: titleStyle,
        content: content,
        primaryLabel: primaryLabel,
        onPrimaryPressed: onPrimaryPressed,
        secondaryLabel: secondaryLabel,
        onSecondaryPressed: onSecondaryPressed,
        padding: padding,
        maxWidth: maxWidth,
        backgroundColor: backgroundColor,
        borderRadius: borderRadius,
        primaryButtonStyle: primaryButtonStyle,
        secondaryButtonStyle: secondaryButtonStyle,
        primaryButtonTextStyle: primaryButtonTextStyle,
        secondaryButtonTextStyle: secondaryButtonTextStyle,
        primaryButtonHeight: primaryButtonHeight,
        secondaryButtonHeight: secondaryButtonHeight,
        showCloseIcon: showCloseIcon,
        onClosePressed: onClosePressed,
        showBorder: showBorder,
        bodyCentered: bodyCentered,
        bodyTextStyle: bodyTextStyle,
        spacingBeforePrimaryButton: spacingBeforePrimaryButton,
        spacingBetweenButtons: spacingBetweenButtons,
      ),
    );
  }

  bool get _showsHeader =>
      title != null || titleWidget != null || showCloseIcon;

  bool get _hasVisibleContent => !_isEmptyPlaceholder(content);

  static bool _isEmptyPlaceholder(Widget widget) {
    if (widget is! SizedBox) return false;

    return widget.child == null &&
        widget.width == null &&
        widget.height == null;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: showBorder ? Border.all(color: AppColors.midGrey) : null,
              boxShadow: AppShadows.defaultCardShadow,
            ),
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_showsHeader)
                    _ModalHeader(
                      title: title,
                      titleWidget: titleWidget,
                      titleStyle: titleStyle,
                      showCloseIcon: showCloseIcon,
                      onClosePressed: onClosePressed,
                    ),
                  if (_hasVisibleContent)
                    _ModalBody(
                      content: content,
                      bodyTextStyle: bodyTextStyle,
                      bodyCentered: bodyCentered,
                    ),
                  SizedBox(height: spacingBeforePrimaryButton),
                  _ModalActionButton(
                    label: primaryLabel,
                    height: primaryButtonHeight,
                    isPrimary: true,
                    textStyle: primaryButtonTextStyle,
                    buttonStyle: _ModalButtonTheme.primary(
                      textStyle: primaryButtonTextStyle,
                      customStyle: primaryButtonStyle,
                      height: primaryButtonHeight,
                    ),
                    onPressed: onPrimaryPressed,
                  ),
                  if (secondaryLabel != null) ...[
                    SizedBox(height: spacingBetweenButtons),
                    _ModalActionButton(
                      label: secondaryLabel!,
                      height: secondaryButtonHeight,
                      isPrimary: false,
                      textStyle: secondaryButtonTextStyle,
                      buttonStyle: _ModalButtonTheme.secondary(
                        textStyle: secondaryButtonTextStyle,
                        customStyle: secondaryButtonStyle,
                        height: secondaryButtonHeight,
                      ),
                      onPressed: onSecondaryPressed,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<T?> _presentDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
  Color? barrierColor,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor:
        barrierColor ?? AppColors.onBackgroundColor.withValues(alpha: 0.6),
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return Transform.scale(
        scale: Tween<double>(begin: 0.92, end: 1).evaluate(curved),
        child: FadeTransition(opacity: curved, child: child),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) => child,
  );
}

abstract final class _ModalButtonTheme {
  static const TextHeightBehavior textHeightBehavior = TextHeightBehavior(
    applyHeightToFirstAscent: false,
    applyHeightToLastDescent: false,
  );

  static TextStyle label(TextStyle? style) {
    return (style ?? AppTextStyle.body2).copyWith(
      height: 1,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static ButtonStyle fixedHeight(double height) {
    return ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size(double.infinity, height)),
      minimumSize: const WidgetStatePropertyAll(Size.zero),
      maximumSize: WidgetStatePropertyAll(Size(double.infinity, height)),
      padding: const WidgetStatePropertyAll(EdgeInsets.zero),
      alignment: Alignment.center,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  static ButtonStyle primary({
    required TextStyle? textStyle,
    required ButtonStyle? customStyle,
    required double height,
  }) {
    final baseStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryColor,
      foregroundColor: AppColors.black,
      disabledBackgroundColor: AppColors.midGrey,
      disabledForegroundColor: AppColors.darkGrey,
      textStyle: label(textStyle),
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: EdgeInsets.zero,
      alignment: Alignment.center,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    return baseStyle
        .merge(customStyle ?? const ButtonStyle())
        .merge(fixedHeight(height));
  }

  static ButtonStyle secondary({
    required TextStyle? textStyle,
    required ButtonStyle? customStyle,
    required double? height,
  }) {
    final baseStyle = TextButton.styleFrom(
      foregroundColor: textStyle?.color ?? AppColors.black,
      textStyle: label(textStyle),
      padding: height == null
          ? const EdgeInsets.symmetric(vertical: 12)
          : EdgeInsets.zero,
      alignment: Alignment.center,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );

    var resolvedStyle = baseStyle.merge(customStyle ?? const ButtonStyle());
    if (height != null) {
      resolvedStyle = resolvedStyle.merge(fixedHeight(height));
    }
    return resolvedStyle;
  }
}

class _ModalHeader extends StatelessWidget {
  const _ModalHeader({
    required this.showCloseIcon,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.onClosePressed,
  });

  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;
  final bool showCloseIcon;
  final UniversalModalPressed? onClosePressed;

  @override
  Widget build(BuildContext context) {
    if (showCloseIcon) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildTitle()),
          IconButton(
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => _handleClose(context),
            icon: const Icon(Icons.close, size: 22, color: AppColors.darkGrey),
          ),
        ],
      );
    }

    return _buildTitle();
  }

  Widget _buildTitle() {
    if (titleWidget != null) {
      return titleWidget!;
    }

    if (title == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: double.infinity,
      child: Text(
        title!,
        style:
            titleStyle ?? AppTextStyle.title.copyWith(color: AppColors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _handleClose(BuildContext context) {
    if (onClosePressed != null) {
      onClosePressed!(context);
      return;
    }
    Navigator.of(context).pop();
  }
}

class _ModalBody extends StatelessWidget {
  const _ModalBody({
    required this.content,
    required this.bodyCentered,
    this.bodyTextStyle,
  });

  final Widget content;
  final bool bodyCentered;
  final TextStyle? bodyTextStyle;

  @override
  Widget build(BuildContext context) {
    if (!bodyCentered) {
      return content;
    }

    return SizedBox(
      width: double.infinity,
      child: DefaultTextStyle.merge(
        style:
            bodyTextStyle ??
            AppTextStyle.body2.copyWith(color: AppColors.black),
        textAlign: TextAlign.center,
        child: content,
      ),
    );
  }
}

class _ModalActionButton extends StatelessWidget {
  const _ModalActionButton({
    required this.label,
    required this.isPrimary,
    required this.buttonStyle,
    required this.onPressed,
    this.textStyle,
    this.height,
  });

  final String label;
  final bool isPrimary;
  final double? height;
  final TextStyle? textStyle;
  final ButtonStyle buttonStyle;
  final UniversalModalPressed? onPressed;

  @override
  Widget build(BuildContext context) {
    final button = isPrimary
        ? ElevatedButton(
            style: buttonStyle,
            onPressed: () => _handlePressed(context),
            child: _buildLabel(),
          )
        : TextButton(
            style: buttonStyle,
            onPressed: () => _handlePressed(context),
            child: _buildLabel(),
          );

    return SizedBox(width: double.infinity, height: height, child: button);
  }

  Widget _buildLabel() {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: _ModalButtonTheme.label(textStyle),
      textHeightBehavior: _ModalButtonTheme.textHeightBehavior,
    );
  }

  void _handlePressed(BuildContext context) {
    if (onPressed != null) {
      onPressed!(context);
      return;
    }
    Navigator.of(context).pop();
  }
}
