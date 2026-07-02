import 'package:hive_flutter/hive_flutter.dart';

/// Ленивая инициализация Hive для локального кеша и key-value storage.
abstract final class HiveBootstrap {
  static Future<void>? _initFuture;

  static Future<void> ensureInitialized() {
    return _initFuture ??= Hive.initFlutter();
  }
}
