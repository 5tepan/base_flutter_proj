import 'dart:async';

import 'package:base_flutter_proj/core/components/bottom_sheet/app_bottom_sheet.dart';
import 'package:base_flutter_proj/core/components/media/config/media_feed_style.dart';
import 'package:base_flutter_proj/core/components/media/feed/media_feed_tile.dart';
import 'package:base_flutter_proj/core/components/media/gallery/media_feed_gallery_viewer.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_content_mode.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/media/picker/app_image_cropper.dart';
import 'package:base_flutter_proj/core/components/media/picker/app_media_picker.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

typedef MediaFeedAddButtonBuilder =
    Widget Function(BuildContext context, VoidCallback onPressed);

/// Горизонтальная медиа-лента с опциональным редактированием.
///
/// [editable] — один флаг: добавление через камеру/галерею и удаление элементов.
/// [contentMode] — только фото, только видео или смешанный режим.
class MediaFeedStrip extends StatelessWidget {
  const MediaFeedStrip({
    super.key,
    required this.items,
    this.onChanged,
    this.editable = false,
    this.contentMode = MediaFeedContentMode.mixed,
    this.style = const MediaFeedStyle(),
    this.maxItems,
    this.cropConfig = const AppImageCropConfig(),
    this.maxVideoDurationSeconds,
    this.imageQuality,
    this.maxWidth,
    this.maxHeight,
    this.onItemTap,
    this.addButtonBuilder,
    this.itemBuilder,
    this.emptyPlaceholder,
    this.addSheetTitle,
    this.cameraOptionLabel,
    this.galleryOptionLabel,
    this.showCameraOption = true,
    this.showGalleryOption = true,
    this.cameraPhotoOptionLabel,
    this.cameraVideoOptionLabel,
  });

  final List<MediaFeedItem> items;
  final ValueChanged<List<MediaFeedItem>>? onChanged;
  final bool editable;
  final MediaFeedContentMode contentMode;
  final MediaFeedStyle style;
  final int? maxItems;
  final AppImageCropConfig cropConfig;
  final int? maxVideoDurationSeconds;
  final int? imageQuality;
  final double? maxWidth;
  final double? maxHeight;
  final void Function(BuildContext context, MediaFeedItem item, int index)?
  onItemTap;
  final MediaFeedAddButtonBuilder? addButtonBuilder;
  final MediaFeedTileBuilder? itemBuilder;
  final Widget? emptyPlaceholder;
  final String? addSheetTitle;
  final String? cameraOptionLabel;
  final String? galleryOptionLabel;
  final bool showCameraOption;
  final bool showGalleryOption;
  final String? cameraPhotoOptionLabel;
  final String? cameraVideoOptionLabel;

  bool get _canAddMore =>
      !editable || maxItems == null || items.length < maxItems!;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (items.isEmpty && emptyPlaceholder != null) {
      children.add(
        SizedBox(
          width: style.itemSize,
          height: style.itemSize,
          child: emptyPlaceholder,
        ),
      );
    }

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      children.add(
        MediaFeedTile(
          item: item,
          style: style,
          editable: editable,
          builder: itemBuilder,
          onRemove: editable && onChanged != null
              ? () => _removeItem(index)
              : null,
          onTap: () {
            if (onItemTap != null) {
              onItemTap!(context, item, index);
              return;
            }
            unawaited(
              MediaFeedGalleryViewer.open(
                context,
                items: items,
                initialIndex: index,
              ),
            );
          },
        ),
      );
    }

    if (editable && _canAddMore) {
      children.add(
        addButtonBuilder?.call(context, () => _onAddPressed(context)) ??
            _DefaultAddButton(
              style: style,
              onPressed: () => _onAddPressed(context),
            ),
      );
    }

    if (children.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: style.padding,
      child: SizedBox(
        height: style.itemSize + (editable ? 8 : 0),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: style.scrollPhysics,
          itemCount: children.length,
          separatorBuilder: (_, __) => Gap(style.spacing),
          itemBuilder: (_, index) => children[index],
        ),
      ),
    );
  }

  void _removeItem(int index) {
    if (onChanged == null) {
      return;
    }
    final next = List<MediaFeedItem>.from(items)..removeAt(index);
    onChanged!(next);
  }

  Future<void> _onAddPressed(BuildContext context) async {
    if (onChanged == null) {
      return;
    }

    final selection = await _pickAddSelection(context);
    if (selection == null || !context.mounted) {
      return;
    }

    final picked = await AppMediaPicker.pickMedia(
      context: context,
      source: selection.source,
      contentMode: contentMode,
      cropConfig: cropConfig,
      maxVideoDurationSeconds: maxVideoDurationSeconds,
      imageQuality: imageQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      preferredType: selection.preferredType,
    );

    if (picked == null) {
      return;
    }

    onChanged!([...items, picked]);
  }

  Future<_MediaAddSelection?> _pickAddSelection(BuildContext context) async {
    final l10n = S.of(context);
    final source = await _pickSource(context);
    if (source == null) {
      return null;
    }

    if (contentMode != MediaFeedContentMode.mixed ||
        source != AppMediaPickerSource.camera) {
      return _MediaAddSelection(source: source);
    }

    if (!context.mounted) {
      return null;
    }

    final preferredType = await AppBottomSheet.show<MediaFeedItemType>(
      context: context,
      title: addSheetTitle ?? l10n.mediaFeedAddTitle,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_outlined),
              title: Text(cameraPhotoOptionLabel ?? l10n.mediaFeedPhoto),
              onTap: () => Navigator.of(sheetContext).pop(
                MediaFeedItemType.photo,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: Text(cameraVideoOptionLabel ?? l10n.mediaFeedVideo),
              onTap: () => Navigator.of(sheetContext).pop(
                MediaFeedItemType.video,
              ),
            ),
          ],
        );
      },
    );

    if (preferredType == null) {
      return null;
    }

    return _MediaAddSelection(
      source: source,
      preferredType: preferredType,
    );
  }

  Future<AppMediaPickerSource?> _pickSource(BuildContext context) async {
    final l10n = S.of(context);
    if (showCameraOption && !showGalleryOption) {
      return AppMediaPickerSource.camera;
    }
    if (showGalleryOption && !showCameraOption) {
      return AppMediaPickerSource.gallery;
    }

    return AppBottomSheet.show<AppMediaPickerSource>(
      context: context,
      title: addSheetTitle ?? l10n.mediaFeedAddTitle,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCameraOption)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(cameraOptionLabel ?? l10n.mediaFeedCamera),
                onTap: () => Navigator.of(sheetContext).pop(
                  AppMediaPickerSource.camera,
                ),
              ),
            if (showGalleryOption)
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: Text(galleryOptionLabel ?? l10n.mediaFeedGallery),
                onTap: () => Navigator.of(sheetContext).pop(
                  AppMediaPickerSource.gallery,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _MediaAddSelection {
  const _MediaAddSelection({
    required this.source,
    this.preferredType,
  });

  final AppMediaPickerSource source;
  final MediaFeedItemType? preferredType;
}

class _DefaultAddButton extends StatelessWidget {
  const _DefaultAddButton({
    required this.style,
    required this.onPressed,
  });

  final MediaFeedStyle style;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.itemSize,
      height: style.itemSize,
      child: Material(
        color: style.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: style.borderRadius,
          side: BorderSide(
            color: style.borderColor,
            width: style.borderWidth,
          ),
        ),
        child: InkWell(
          borderRadius: style.borderRadius,
          onTap: onPressed,
          child: Icon(
            style.addButtonIcon,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
