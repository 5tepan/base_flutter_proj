import 'dart:io' as io;

import 'package:flutter/foundation.dart';

enum _AppPlatform { web, ios, android }

abstract final class AppPlatform {
  static bool get isWeb => kIsWeb;

  static bool get isMobile => isAndroid || isIOS;

  static bool get isIOS => !kIsWeb && io.Platform.isIOS;

  static bool get isAndroid => !kIsWeb && io.Platform.isAndroid;

  static _AppPlatform get platform {
    if (kIsWeb) {
      return _AppPlatform.web;
    }
    if (io.Platform.isIOS) {
      return _AppPlatform.ios;
    }
    return _AppPlatform.android;
  }
}
