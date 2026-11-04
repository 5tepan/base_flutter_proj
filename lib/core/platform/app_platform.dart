import 'package:flutter/foundation.dart';

enum _AppPlatform { web, ios, android }

abstract final class AppPlatform {
  static bool get isWeb => kIsWeb;

  static bool get isMobile => isAndroid || isIOS;

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static _AppPlatform get platform {
    if (kIsWeb) {
      return _AppPlatform.web;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _AppPlatform.ios;
    }
    return _AppPlatform.android;
  }
}
