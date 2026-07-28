import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Сброс badge и очистка доставленных уведомлений при открытии приложения.
///
/// Нативная реализация: MethodChannel `com.base.base_flutter_proj/notifications`.
abstract final class NotificationBadgeCleaner {
  static const _channel = MethodChannel(
    'com.base.base_flutter_proj/notifications',
  );

  static Future<void> clearOnAppOpen() async {
    if (!AppPlatform.isMobile) {
      return;
    }

    try {
      await _channel.invokeMethod<void>('clearAll');
      CustomLogger.info('Notification badge cleared');
    } catch (error, stackTrace) {
      CustomLogger.warning('Failed to clear notification badge: $error');
      if (kDebugMode) {
        debugPrint('$stackTrace');
      }
    }
  }
}
