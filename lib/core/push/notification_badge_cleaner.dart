import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:clear_all_notifications/clear_all_notifications.dart';
import 'package:flutter/foundation.dart';

/// Сброс badge и очистка доставленных уведомлений при открытии приложения.
abstract final class NotificationBadgeCleaner {
  static Future<void> clearOnAppOpen() async {
    if (!AppPlatform.isMobile) {
      return;
    }

    try {
      await ClearAllNotifications.clear();
      CustomLogger.info('Notification badge cleared');
    } catch (error, stackTrace) {
      CustomLogger.warning('Failed to clear notification badge: $error');
      if (kDebugMode) {
        debugPrint('$stackTrace');
      }
    }
  }
}
