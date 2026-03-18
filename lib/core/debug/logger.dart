import 'dart:async';

import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/debug/event_bus_log.dart';
import 'package:base_flutter_proj/core/debug/http_log_interceptor.dart';
import 'package:base_flutter_proj/core/events/event.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

typedef LogEmit =
    void Function(Object msg, [Object? exception, StackTrace? stackTrace]);

// Класс для удобства работы с Talker
abstract final class CustomLogger {
  static late final Talker _talker;

  static LogEmit error = _talker.error;
  static LogEmit warning = _talker.warning;
  static LogEmit info = _talker.info;
  static LogEmit verbose = _talker.verbose;

  static String routeName = 'talker';

  // static AppGoRoute talkerRoute() => AppGoRoute(
  //   path: '/$routeName',
  //   name: routeName,
  //   builder: (context, state) => TalkerScreen(talker: _talker),
  // );

  static bool get _isWeb => AppPlatform.isWeb;

  // ignore: unnecessary_late
  static late final HTTPLogInterceptor httpInterceptor = HTTPLogInterceptor(
    talker: _talker,
  );

  static void init() {
    _talker = TalkerFlutter.init();

    _talker.stream.listen((event) {
      if (event is TalkerError) {
        if (!_isWeb) {
          FirebaseCrashlytics.instance.recordError(
            event.error,
            event.stackTrace,
          );
        }
      }
    });
    FlutterError.onError = onFlutterError;

    PlatformDispatcher.instance.onError = (error, stack) {
      CustomLogger.onError(error, stack);
      return true;
    };

    if (!_isWeb) {
      FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
  }

  static StreamSubscription? _subscription;

  static void registerEventBusLogger(EventBus eventBus) {
    if (_subscription != null) {
      _subscription!.cancel();
      _subscription = null;
      warning('Сброс прослушивания EventBus');
    }

    _subscription = eventBus.on<BaseEvent>().listen((event) {
      _talker.logCustom(EventBusLogEvent(event));
    });
  }

  static void onFlutterError(FlutterErrorDetails details) {
    _talker.error(details.exception, details.stack);
    if (!_isWeb) FirebaseCrashlytics.instance.recordFlutterError(details);
  }

  static void onError(Object error, StackTrace stack) {
    _talker.error(error, stack);
  }
}
