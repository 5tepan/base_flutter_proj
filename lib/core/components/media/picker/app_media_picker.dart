import 'dart:math';

import 'package:base_flutter_proj/core/components/files/app_file_utils.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_content_mode.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/media/picker/app_image_cropper.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Источник выбора медиа.
enum AppMediaPickerSource {
  camera,
  gallery,
}

abstract final class AppMediaPicker {
  static final ImagePicker _picker = ImagePicker();

  static String createItemId() =>
      '${DateTime.now().microsecondsSinceEpoch}_${Random().nextInt(1 << 32)}';

  static Future<MediaFeedItem?> pickMedia({
    required BuildContext context,
    required AppMediaPickerSource source,
    required MediaFeedContentMode contentMode,
    AppImageCropConfig cropConfig = const AppImageCropConfig(),
    int? maxVideoDurationSeconds,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    MediaFeedItemType? preferredType,
  }) async {
    try {
      final imageSource = switch (source) {
        AppMediaPickerSource.camera => ImageSource.camera,
        AppMediaPickerSource.gallery => ImageSource.gallery,
      };

      return switch (contentMode) {
        MediaFeedContentMode.photosOnly => _pickPhoto(
          context: context,
          source: imageSource,
          cropConfig: cropConfig,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
        ),
        MediaFeedContentMode.videosOnly => _pickVideo(
          source: imageSource,
          maxDuration: maxVideoDurationSeconds,
        ),
        MediaFeedContentMode.mixed => _pickMixed(
          context: context,
          source: imageSource,
          cropConfig: cropConfig,
          maxVideoDurationSeconds: maxVideoDurationSeconds,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          preferredType: preferredType,
        ),
      };
    } catch (error, stackTrace) {
      CustomLogger.warning('Не удалось выбрать медиа: $error');
      CustomLogger.verbose('$stackTrace');
      return null;
    }
  }

  static Future<MediaFeedItem?> _pickPhoto({
    required BuildContext context,
    required ImageSource source,
    required AppImageCropConfig cropConfig,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
  }) async {
    final picked = await _picker.pickImage(
      source: source,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (picked == null) {
      return null;
    }

    if (!context.mounted) {
      return null;
    }

    final cropped = await AppImageCropper.cropImageFile(
      context: context,
      source: picked,
      config: cropConfig,
    );
    if (cropped == null) {
      return null;
    }

    return MediaFeedItem(
      id: createItemId(),
      type: MediaFeedItemType.photo,
      localFile: cropped,
    );
  }

  static Future<MediaFeedItem?> _pickVideo({
    required ImageSource source,
    int? maxDuration,
  }) async {
    final picked = await _picker.pickVideo(
      source: source,
      maxDuration: maxDuration == null ? null : Duration(seconds: maxDuration),
    );
    if (picked == null) {
      return null;
    }

    return MediaFeedItem(
      id: createItemId(),
      type: MediaFeedItemType.video,
      localFile: picked,
    );
  }

  static Future<MediaFeedItem?> _pickMixed({
    required BuildContext context,
    required ImageSource source,
    required AppImageCropConfig cropConfig,
    int? maxVideoDurationSeconds,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    MediaFeedItemType? preferredType,
  }) async {
    if (source == ImageSource.camera &&
        preferredType == MediaFeedItemType.video) {
      return _pickVideo(
        source: source,
        maxDuration: maxVideoDurationSeconds,
      );
    }

    if (source == ImageSource.camera) {
      return _pickPhoto(
        context: context,
        source: source,
        cropConfig: cropConfig,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );
    }

    final picked = await _picker.pickMedia(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    if (picked == null) {
      return null;
    }

    final mime = AppFileUtils.guessMimeType(path: picked.path);
    final isVideo = AppFileUtils.isVideoMime(mime) ||
        AppFileUtils.isVideoPath(picked.path);

    if (isVideo) {
      return MediaFeedItem(
        id: createItemId(),
        type: MediaFeedItemType.video,
        localFile: picked,
      );
    }

    if (!context.mounted) {
      return null;
    }

    final cropped = await AppImageCropper.cropImageFile(
      context: context,
      source: picked,
      config: cropConfig,
    );
    if (cropped == null) {
      return null;
    }

    return MediaFeedItem(
      id: createItemId(),
      type: MediaFeedItemType.photo,
      localFile: cropped,
    );
  }
}
