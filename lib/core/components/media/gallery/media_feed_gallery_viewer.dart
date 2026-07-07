import 'package:base_flutter_proj/core/components/media/gallery/widgets/media_feed_gallery_page.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Полноэкранная галерея медиа-ленты с перелистыванием между элементами.
abstract final class MediaFeedGalleryViewer {
  static Future<void> open(
    BuildContext context, {
    required List<MediaFeedItem> items,
    required int initialIndex,
    bool allowShare = true,
  }) {
    if (items.isEmpty) {
      return Future<void>.value();
    }

    final safeIndex = initialIndex.clamp(0, items.length - 1);

    return Navigator.of(context).push<void>(
      PageRouteBuilder<void>(
        fullscreenDialog: true,
        opaque: true,
        barrierColor: AppColors.black,
        pageBuilder: (context, animation, secondaryAnimation) {
          return MediaFeedGalleryPage(
            items: items,
            initialIndex: safeIndex,
            allowShare: allowShare,
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
}
