import 'dart:io';

import 'package:base_flutter_proj/core/components/media/gallery/config/media_feed_gallery_gesture_config.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MediaFeedGalleryPhotoPage extends StatelessWidget {
  const MediaFeedGalleryPhotoPage({super.key, required this.item});

  final MediaFeedItem item;

  static const _dismissOffset = 80.0;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final localPath = item.localFile?.path;
    final remoteUrl = item.remoteUrl;

    Widget? content;
    if (localPath != null && localPath.isNotEmpty) {
      content = ExtendedImage.file(
        File(localPath),
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        enableSlideOutPage: true,
        initGestureConfigHandler: (_) => mediaFeedGalleryGestureConfig,
      );
    } else if (remoteUrl != null && remoteUrl.isNotEmpty) {
      content = ExtendedImage.network(
        remoteUrl,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.gesture,
        enableSlideOutPage: true,
        initGestureConfigHandler: (_) => mediaFeedGalleryGestureConfig,
        loadStateChanged: (state) {
          if (state.extendedImageLoadState == LoadState.failed) {
            return Center(
              child: Text(
                l10n.fileViewerPreviewUnavailable,
                style: AppTextStyle.body.copyWith(color: AppColors.white),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (state.extendedImageLoadState != LoadState.completed) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            );
          }
          return null;
        },
      );
    }

    if (content == null) {
      return Center(
        child: Text(
          l10n.fileViewerPreviewUnavailable,
          style: AppTextStyle.body.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ExtendedImageSlidePage(
      slideAxis: SlideAxis.vertical,
      slideEndHandler: (
        Offset offset, {
        ExtendedImageSlidePageState? state,
        ScaleEndDetails? details,
      }) {
        return offset.dy.abs() >= _dismissOffset;
      },
      child: Center(child: content),
    );
  }
}
