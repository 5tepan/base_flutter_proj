import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/model/entities/app_settings.dart';
import 'package:base_flutter_proj/core/network/connectivity_utils.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';
import 'package:base_flutter_proj/core/network/settings_api.dart';
import 'package:base_flutter_proj/core/storage/hive_bootstrap.dart';
import 'package:base_flutter_proj/firebase_options.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Инициализация инфраструктуры приложения до `runApp`.
abstract final class AppBootstrap {
  static bool isFirebaseInitialized = false;

  static Future<AppSettings> initialize({
    required Config config,
    required PackageInfo packageInfo,
  }) async {
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

    await HiveBootstrap.ensureInitialized();

    return _loadAppSettings(config, packageInfo);
  }

  static Future<AppSettings> _loadAppSettings(
    Config config,
    PackageInfo packageInfo,
  ) async {
    final api = SettingsApi(
      useMock: config.useMockAppSettingsApi,
      publicApi: PublicApi(
        config: config,
        packageInfo: packageInfo,
        checkConnection: () async {
          final result = await Connectivity().checkConnectivity();
          return isConnected(result);
        },
      ),
    );

    try {
      return await api.load();
    } catch (error, stackTrace) {
      CustomLogger.warning(
        'App settings load failed, using defaults: $error',
        error,
        stackTrace,
      );
      return AppSettings.defaults;
    }
  }
}
