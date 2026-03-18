import 'dart:async';

import 'package:base_flutter_proj/core/application.dart';
import 'package:base_flutter_proj/core/config.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// App launch.
Future<void> run(Config env) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();

  await _prepareSystemChrome();
  _runApp(env);
}

void _runApp(Config config) {
  runApp(
    ProviderScope(
      overrides: [configProvider.overrideWithValue(config)],
      child: const Application(),
    ),
  );
}

Future<void> _prepareSystemChrome() async {
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(ThemeBuilder.systemUiOverlayStyle);
}
