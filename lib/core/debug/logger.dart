import 'dart:async';

import 'package:base_flutter_proj/core/debug/event_bus_log.dart';
import 'package:base_flutter_proj/core/debug/http_log_interceptor.dart';
import 'package:base_flutter_proj/core/events/event.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

typedef LogEmit =
    void Function(Object msg, [Object? exception, StackTrace? stackTrace]);

// Класс для удобства работы с Talker
abstract final class CustomLogger {
  static late final Talker _talker;
  static bool _isInitialized = false;
  static bool _isTalkerCreated = false;

  static String routeName = 'talker';

  // static AppGoRoute talkerRoute() => AppGoRoute(
  //   path: '/$routeName',
  //   name: routeName,
  //   builder: (context, state) => TalkerScreen(talker: _talker),
  // );

  static bool get _isWeb => AppPlatform.isWeb;

  static late final HTTPLogInterceptor _httpInterceptor = HTTPLogInterceptor(
    talker: _ensureTalker(),
  );

  static HTTPLogInterceptor get httpInterceptor => _httpInterceptor;

  static void error(Object msg, [Object? exception, StackTrace? stackTrace]) {
    _ensureTalker().error(msg, exception, stackTrace);
  }

  static void warning(Object msg, [Object? exception, StackTrace? stackTrace]) {
    _ensureTalker().warning(msg, exception, stackTrace);
  }

  static void info(Object msg, [Object? exception, StackTrace? stackTrace]) {
    _ensureTalker().info(msg, exception, stackTrace);
  }

  static void verbose(Object msg, [Object? exception, StackTrace? stackTrace]) {
    _ensureTalker().verbose(msg, exception, stackTrace);
  }

  static void init() {
    _ensureTalker();
    if (_isInitialized) {
      return;
    }

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
    _isInitialized = true;
  }

  static Talker _ensureTalker() {
    if (_isTalkerCreated) {
      return _talker;
    }
    _talker = TalkerFlutter.init();
    _isTalkerCreated = true;
    return _talker;
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
