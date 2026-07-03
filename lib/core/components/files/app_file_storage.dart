import 'dart:io';
import 'dart:typed_data';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:downloadsfolder/downloadsfolder.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract final class AppFileStorage {
  static Future<String> writeTempFile({
    required Uint8List bytes,
    required String extension,
    String prefix = 'app_',
  }) async {
    final directory = await getTemporaryDirectory();
    final fileName =
        '$prefix${DateTime.now().microsecondsSinceEpoch}.$extension';
    final file = File(p.join(directory.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<String?> copyToDownloads({
    required String sourcePath,
    String? fileName,
  }) async {
    if (!AppPlatform.isMobile) {
      CustomLogger.warning('copyToDownloads доступен только на мобильных.');
      return null;
    }

    final resolvedName = fileName ?? p.basename(sourcePath);
    try {
      final copied = await copyFileIntoDownloadFolder(
        sourcePath,
        resolvedName,
      );
      if (copied == true) {
        final downloads = await getDownloadDirectory();
        return p.join(downloads.path, resolvedName);
      }
    } catch (error, stackTrace) {
      CustomLogger.warning('Не удалось сохранить в Downloads: $error');
      CustomLogger.verbose('$stackTrace');
    }
    return null;
  }
}
