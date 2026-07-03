import 'dart:io';

import 'package:base_flutter_proj/core/components/media/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/media/media_feed_style.dart';
import 'package:base_flutter_proj/core/components/safe_network_image.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

typedef MediaFeedTileBuilder =
    Widget Function(
      BuildContext context,
      MediaFeedItem item,
      VoidCallback? onRemove,
    );

/// Плитка одного элемента медиа-ленты.
class MediaFeedTile extends StatelessWidget {
  const MediaFeedTile({
    super.key,
    required this.item,
    required this.style,
    this.editable = false,
    this.onTap,
    this.onRemove,
    this.builder,
  });

  final MediaFeedItem item;
  final MediaFeedStyle style;
  final bool editable;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;
  final MediaFeedTileBuilder? builder;

  @override
  Widget build(BuildContext context) {
    if (builder != null) {
      return SizedBox(
        width: style.itemSize,
        height: style.itemSize,
        child: builder!(
          context,
          item,
          editable ? onRemove : null,
        ),
      );
    }

    return SizedBox(
      width: style.itemSize,
      height: style.itemSize,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Material(
              color: style.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: style.borderRadius,
                side: BorderSide(
                  color: style.borderColor,
                  width: style.borderWidth,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onTap,
                child: _MediaPreview(item: item, style: style),
              ),
            ),
          ),
          if (editable && onRemove != null)
            Positioned(
              top: -6,
              right: -6,
              child: _RemoveButton(
                style: style,
                onPressed: onRemove!,
              ),
            ),
        ],
      ),
    );
  }
}

class _MediaPreview extends StatelessWidget {
  const _MediaPreview({
    required this.item,
    required this.style,
  });

  final MediaFeedItem item;
  final MediaFeedStyle style;

  @override
  Widget build(BuildContext context) {
    final preview = item.previewSource;

    Widget content;
    if (item.hasLocalFile && preview != null) {
      content = Image.file(
        File(preview),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _BrokenPreview(),
      );
    } else if (preview != null && preview.isNotEmpty) {
      content = SafeNetworkImage(
        imageUrl: preview,
        fit: BoxFit.cover,
      );
    } else {
      content = const _BrokenPreview();
    }

    if (!item.isVideo) {
      return content;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        content,
        Container(
          color: AppColors.black.withValues(alpha: 0.25),
          alignment: Alignment.center,
          child: Icon(
            style.videoOverlayIcon,
            color: style.videoOverlayColor,
            size: style.itemSize * 0.35,
          ),
        ),
      ],
    );
  }
}

class _BrokenPreview extends StatelessWidget {
  const _BrokenPreview();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.lightGrey,
      child: Center(
        child: Icon(Icons.broken_image_outlined, color: AppColors.grey),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({
    required this.style,
    required this.onPressed,
  });

  final MediaFeedStyle style;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: style.removeButtonBackgroundColor,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            style.removeButtonIcon,
            size: 16,
            color: style.removeButtonColor,
          ),
        ),
      ),
    );
  }
}
