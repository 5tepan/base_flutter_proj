import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:http/http.dart' as http;

/// Подготовка локальных [MediaFeedItem] к отправке на сервер (multipart).
abstract final class MediaUploadHelper {
  /// Элементы с локальным файлом, готовые к загрузке.
  static List<MediaFeedItem> localItems(List<MediaFeedItem> items) {
    return items.where((item) => item.hasLocalFile).toList(growable: false);
  }

  static bool hasLocalItems(List<MediaFeedItem> items) {
    return items.any((item) => item.hasLocalFile);
  }

  /// Конвертирует локальные элементы ленты в [http.MultipartFile].
  static Future<List<http.MultipartFile>> toMultipartFiles(
    List<MediaFeedItem> items, {
    String fieldName = 'files[]',
  }) async {
    final files = <http.MultipartFile>[];
    for (final item in localItems(items)) {
      final localFile = item.localFile!;
      final bytes = await localFile.readAsBytes();
      files.add(
        http.MultipartFile.fromBytes(
          fieldName,
          bytes,
          filename: _resolveFileName(item),
        ),
      );
    }
    return files;
  }

  static String _resolveFileName(MediaFeedItem item) {
    final localFile = item.localFile;
    if (localFile == null) {
      return 'attachment_${item.id}';
    }
    if (localFile.name.isNotEmpty) {
      return localFile.name;
    }
    final path = localFile.path;
    if (path.isNotEmpty) {
      final separatorIndex = path.lastIndexOf('/');
      if (separatorIndex >= 0 && separatorIndex < path.length - 1) {
        return path.substring(separatorIndex + 1);
      }
      return path;
    }
    return 'attachment_${item.id}';
  }
}
