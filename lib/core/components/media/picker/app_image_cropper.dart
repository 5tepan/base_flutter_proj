import 'dart:io';
import 'dart:ui' as ui;

import 'package:base_flutter_proj/core/components/files/app_file_storage.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:croppy/croppy.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

/// Настройки обрезки изображения при добавлении в ленту.
class AppImageCropConfig {
  const AppImageCropConfig({
    this.enabled = true,
    this.allowedAspectRatios,
    this.useAdaptiveCropper = true,
  });

  final bool enabled;
  final List<CropAspectRatio?>? allowedAspectRatios;
  final bool useAdaptiveCropper;
}

abstract final class AppImageCropper {
  static Future<XFile?> cropImageFile({
    required BuildContext context,
    required XFile source,
    AppImageCropConfig config = const AppImageCropConfig(),
  }) async {
    if (!config.enabled) {
      return source;
    }

    final imageProvider = FileImage(File(source.path));
    final CropImageResult? result;
    if (config.useAdaptiveCropper) {
      result = await showAdaptiveImageCropper(
        context,
        imageProvider: imageProvider,
        allowedAspectRatios: config.allowedAspectRatios,
      );
    } else {
      result = await showMaterialImageCropper(
        context,
        imageProvider: imageProvider,
        allowedAspectRatios: config.allowedAspectRatios,
      );
    }

    if (result == null) {
      return null;
    }

    try {
      final byteData = await result.uiImage.toByteData(
        format: ui.ImageByteFormat.png,
      );
      if (byteData == null) {
        return null;
      }

      final path = await AppFileStorage.writeTempFile(
        bytes: byteData.buffer.asUint8List(),
        extension: 'png',
        prefix: 'cropped_',
      );
      return XFile(path);
    } catch (error, stackTrace) {
      CustomLogger.warning('Не удалось сохранить обрезанное изображение: $error');
      CustomLogger.verbose('$stackTrace');
      return null;
    }
  }
}
