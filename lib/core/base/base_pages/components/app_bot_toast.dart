import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class AppBotToast {
  static void showMessage(
    String? message, {
    bool isErrorMessage = false,
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    Color? backgroundColor,
    bool onlyOne = true,
  }) {
    if (message?.isEmpty ?? true) {
      CustomLogger.warning('Empty message to display in snackbar');
      return;
    }
    CustomLogger.info("Отправлен тост: $message");
    BotToast.showCustomText(
      duration: const Duration(seconds: 4),
      align: Alignment.bottomCenter,
      onlyOne: onlyOne,
      toastBuilder: (_) => Container(
        decoration: BoxDecoration(
          color:
              backgroundColor ??
              (isErrorMessage ? AppColors.errorColor : AppColors.green),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: margin,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 22),
          child: Text(
            message!,
            style: AppTextStyle.body.copyWith(
              color: AppColors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  static void showError(
    String? message, {
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    Color? backgroundColor,
    bool onlyOne = true,
  }) {
    showMessage(
      message,
      isErrorMessage: true,
      margin: margin,
      backgroundColor: backgroundColor,
      onlyOne: onlyOne,
    );
  }

  static void showInformMessage(
    String? message, {
    EdgeInsets margin = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    Color? backgroundColor,
    bool onlyOne = true,
  }) {
    showMessage(
      message,
      isErrorMessage: true,
      margin: margin,
      backgroundColor: AppColors.primaryColor,
      onlyOne: onlyOne,
    );
  }

  static void showNotificationWithOkButton({
    VoidCallback? onOkButtonTap,
    String? message,
    Duration? duration,
    String trailingText = 'Oк',
  }) {
    if (message == null) {
      CustomLogger.warning('Empty message to display in snackbar');
      return;
    }
    BotToast.showNotification(
      backgroundColor: AppColors.green,
      borderRadius: 16.0,
      enableSlideOff: true,
      align: const Alignment(0, 0.9),
      duration: duration,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      title: (_) => Text(
        message,
        style: AppTextStyle.body.copyWith(color: AppColors.white, fontSize: 15),
      ),
      trailing: (cancelFunc) => TextButton(
        onPressed: () {
          onOkButtonTap?.call();
          cancelFunc.call();
        },
        child: Text(
          trailingText,
          style: AppTextStyle.body.copyWith(
            color: AppColors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
