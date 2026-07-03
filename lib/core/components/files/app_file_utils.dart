import 'dart:io';

import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

abstract final class AppFileUtils {
  static String fileNameFromPath(String path) => p.basename(path);

  static String extensionFromName(String name) =>
      p.extension(name).replaceFirst('.', '').toLowerCase();

  static String? guessMimeType({String? path, String? name}) {
    if (path != null) {
      final fromPath = lookupMimeType(path);
      if (fromPath != null) {
        return fromPath;
      }
    }
    if (name != null) {
      return lookupMimeType(name);
    }
    return null;
  }

  static Future<int?> fileSizeBytes(String path) async {
    try {
      return await File(path).length();
    } catch (_) {
      return null;
    }
  }

  static String formatFileSize(int? bytes) {
    if (bytes == null || bytes <= 0) {
      return '';
    }
    const units = ['B', 'KB', 'MB', 'GB'];
    var size = bytes.toDouble();
    var unitIndex = 0;
    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }
    final precision = unitIndex == 0 ? 0 : 1;
    return '${size.toStringAsFixed(precision)} ${units[unitIndex]}';
  }

  static bool isImageMime(String? mimeType) =>
      mimeType?.startsWith('image/') ?? false;

  static bool isVideoMime(String? mimeType) =>
      mimeType?.startsWith('video/') ?? false;

  static bool isAudioMime(String? mimeType) =>
      mimeType?.startsWith('audio/') ?? false;

  static bool isPdfMime(String? mimeType) =>
      mimeType == 'application/pdf' || mimeType?.endsWith('/pdf') == true;

  static bool isImagePath(String path) {
    final mime = guessMimeType(path: path);
    return isImageMime(mime) ||
        const {'jpg', 'jpeg', 'png', 'gif', 'webp', 'heic'}.contains(
          extensionFromName(path),
        );
  }

  static bool isVideoPath(String path) {
    final mime = guessMimeType(path: path);
    return isVideoMime(mime) ||
        const {'mp4', 'mov', 'avi', 'mkv', 'webm'}.contains(
          extensionFromName(path),
        );
  }

  static bool isAudioPath(String path) {
    final mime = guessMimeType(path: path);
    return isAudioMime(mime) ||
        const {'mp3', 'wav', 'aac', 'm4a', 'ogg'}.contains(
          extensionFromName(path),
        );
  }

  static bool isPdfPath(String path) {
    final mime = guessMimeType(path: path);
    return isPdfMime(mime) || extensionFromName(path) == 'pdf';
  }
}
