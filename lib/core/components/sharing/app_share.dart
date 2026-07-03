import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// Обёртка над [SharePlus] для шаринга ссылок, текста и файлов.
abstract final class AppShare {
  static Future<void> shareLink({
    required String url,
    String? subject,
    String? text,
  }) async {
    final message = [if (text != null && text.isNotEmpty) text, url]
        .join('\n')
        .trim();
    await _share(ShareParams(text: message, subject: subject));
  }

  static Future<void> shareText({
    required String text,
    String? subject,
  }) async {
    await _share(ShareParams(text: text, subject: subject));
  }

  static Future<void> shareFiles({
    required List<String> paths,
    String? text,
    String? subject,
  }) async {
    if (paths.isEmpty) {
      return;
    }

    await _share(
      ShareParams(
        files: paths.map(XFile.new).toList(),
        text: text,
        subject: subject,
      ),
    );
  }

  static Future<void> shareXFiles({
    required List<XFile> files,
    String? text,
    String? subject,
  }) async {
    if (files.isEmpty) {
      return;
    }

    await _share(
      ShareParams(
        files: files,
        text: text,
        subject: subject,
      ),
    );
  }

  static Future<void> _share(ShareParams params) async {
    try {
      await SharePlus.instance.share(params);
    } catch (error, stackTrace) {
      CustomLogger.warning('Не удалось поделиться: $error');
      if (kDebugMode) {
        debugPrint('$stackTrace');
      }
    }
  }
}
