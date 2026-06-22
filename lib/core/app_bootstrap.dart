import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Инициализация инфраструктуры приложения до `runApp`.
abstract final class AppBootstrap {
  static bool isFirebaseInitialized = false;

  static Future<void> initialize(Config config) async {
    if (config.enableFirebase && !AppPlatform.isWeb) {
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        isFirebaseInitialized = true;
      } catch (error, stackTrace) {
        debugPrint('Firebase initialization failed: $error');
        if (kDebugMode) {
          debugPrint('$stackTrace');
        }
      }
    }

    CustomLogger.init(
      enableCrashlytics: isFirebaseInitialized && config.enableFirebase,
    );
  }
}
