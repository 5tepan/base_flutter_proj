abstract final class AppMapBootstrap {
  static bool isInitialized = false;

  static Future<void> initialize({required String apiKey}) async {}
  static void notifyMapViewStarted() {}
  static void notifyMapViewStopped() {}
  static void onAppResumed() {}
  static void onAppPaused() {}
}
