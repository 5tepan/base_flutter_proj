import 'dart:async';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/env_reader.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/push/push_background_handler.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:base_flutter_proj/runner.dart';

void main() async {
  final config = EnvReader.getConfig();
  if (config.enableFirebase && !AppPlatform.isWeb) {
    FirebaseMessaging.onBackgroundMessage(pushBackgroundHandler);
  }

  await runZonedGuarded(() async {
    await run(config);
  }, CustomLogger.onError);
}
