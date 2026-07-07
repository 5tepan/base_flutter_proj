import 'package:cross_file/cross_file.dart';

/// Тип элемента в медиа-ленте.
enum MediaFeedItemType {
  photo,
  video,
}

/// Элемент медиа-ленты: локальный файл или удалённый URL.
class MediaFeedItem {
  MediaFeedItem({
    required this.id,
    required this.type,
    this.localFile,
    this.remoteUrl,
    this.thumbnailUrl,
  }) : assert(
         localFile != null || (remoteUrl != null && remoteUrl.isNotEmpty),
         'Нужен localFile или remoteUrl.',
       );

  final String id;
  final MediaFeedItemType type;
  final XFile? localFile;
  final String? remoteUrl;
  final String? thumbnailUrl;

  bool get isPhoto => type == MediaFeedItemType.photo;
  bool get isVideo => type == MediaFeedItemType.video;
  bool get hasLocalFile => localFile != null;

  String? get previewSource {
    if (localFile != null) {
      return localFile!.path;
    }
    if (isPhoto) {
      return remoteUrl ?? thumbnailUrl;
    }
    return thumbnailUrl ?? remoteUrl;
  }

  MediaFeedItem copyWith({
    String? id,
    MediaFeedItemType? type,
    XFile? localFile,
    String? remoteUrl,
    String? thumbnailUrl,
  }) {
    return MediaFeedItem(
      id: id ?? this.id,
      type: type ?? this.type,
      localFile: localFile ?? this.localFile,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
