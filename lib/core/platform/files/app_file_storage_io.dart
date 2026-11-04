import 'dart:io';
import 'dart:typed_data';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/platform/app_platform.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

abstract final class AppFileStorage {
  static Future<XFile> writeTempFile({
    required Uint8List bytes,
    required String extension,
    String prefix = 'app_',
  }) async {
    final directory = await getTemporaryDirectory();
    final fileName =
        '$prefix${DateTime.now().microsecondsSinceEpoch}.$extension';
    final file = File(p.join(directory.path, fileName));
    await file.writeAsBytes(bytes, flush: true);
    return XFile(file.path, name: fileName);
  }

  static Future<String?> copyToDownloads({
    required String sourcePath,
    XFile? sourceFile,
    String? fileName,
  }) async {
    if (!AppPlatform.isMobile) {
      CustomLogger.warning('copyToDownloads доступен только на мобильных.');
      return null;
    }

    final resolvedName = fileName ?? p.basename(sourcePath);
    final extension = p.extension(resolvedName).replaceFirst('.', '');
    final name = p.basenameWithoutExtension(resolvedName);

    try {
      final savedPath = await FileSaver.instance.saveFile(
        name: name,
        filePath: sourcePath,
        fileExtension: extension,
      );
      if (savedPath.isEmpty) {
        return null;
      }
      return savedPath;
    } catch (error, stackTrace) {
      CustomLogger.warning('Не удалось сохранить в Downloads: $error');
      CustomLogger.verbose('$stackTrace');
    }
    return null;
  }
}
