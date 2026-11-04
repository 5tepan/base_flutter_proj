import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/platform/app_platform.dart';
import 'package:yandex_maps_mapkit_lite/init.dart' as mapkit_init;
import 'package:yandex_maps_mapkit_lite/mapkit_factory.dart';

/// Инициализация Yandex MapKit до `runApp`.
abstract final class AppMapBootstrap {
  static bool isInitialized = false;
  static int _activeMapViews = 0;

  static Future<void> initialize({required String apiKey}) async {
    if (!AppPlatform.isMobile) {
      return;
    }
    if (apiKey.trim().isEmpty) {
      CustomLogger.warning(
        'MAPKIT_API_KEY is empty: MapKit will not be initialized',
      );
      return;
    }

    try {
      await mapkit_init.initMapkit(apiKey: apiKey.trim());
      isInitialized = true;
    } catch (error, stackTrace) {
      CustomLogger.error(
        'MapKit initialization failed: $error',
        error,
        stackTrace,
      );
    }
  }

  /// Учитывает несколько [AppMapView]: `onStop` только когда все закрыты.
  static void notifyMapViewStarted() {
    if (!isInitialized) {
      return;
    }
    if (_activeMapViews == 0) {
      mapkit.onStart();
    }
    _activeMapViews += 1;
  }

  static void notifyMapViewStopped() {
    if (!isInitialized) {
      return;
    }
    if (_activeMapViews == 0) {
      return;
    }
    _activeMapViews -= 1;
    if (_activeMapViews == 0) {
      mapkit.onStop();
    }
  }

  static void onAppResumed() {
    if (!isInitialized || _activeMapViews == 0) {
      return;
    }
    mapkit.onStart();
  }

  static void onAppPaused() {
    if (!isInitialized || _activeMapViews == 0) {
      return;
    }
    mapkit.onStop();
  }
}
