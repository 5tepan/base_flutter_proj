import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_saver/file_saver.dart';
import 'package:path/path.dart' as p;

abstract final class AppFileStorage {
  static Future<XFile> writeTempFile({
    required Uint8List bytes,
    required String extension,
    String prefix = 'app_',
  }) async {
    final name = '$prefix${DateTime.now().microsecondsSinceEpoch}.$extension';
    return XFile.fromData(bytes, name: name, mimeType: _mimeType(extension));
  }

  static Future<String?> copyToDownloads({
    required String sourcePath,
    XFile? sourceFile,
    String? fileName,
  }) async {
    final resolvedName = fileName ?? sourceFile?.name ?? p.basename(sourcePath);
    final extension = p.extension(resolvedName).replaceFirst('.', '');
    final name = p.basenameWithoutExtension(resolvedName);
    try {
      return await FileSaver.instance.saveFile(
        name: name,
        bytes: await (sourceFile ?? XFile(sourcePath)).readAsBytes(),
        fileExtension: extension,
      );
    } catch (_) {
      return null;
    }
  }

  static String _mimeType(String extension) =>
      switch (extension.toLowerCase()) {
        'png' => 'image/png',
        'jpg' || 'jpeg' => 'image/jpeg',
        'pdf' => 'application/pdf',
        _ => 'application/octet-stream',
      };
}
