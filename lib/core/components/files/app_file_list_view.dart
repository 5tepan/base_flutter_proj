import 'package:base_flutter_proj/core/components/files/app_file_item.dart';
import 'package:base_flutter_proj/core/components/files/app_file_utils.dart';
import 'package:base_flutter_proj/core/components/files/app_file_viewer.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

typedef AppFileListTileBuilder =
    Widget Function(
      BuildContext context,
      AppFileItem item,
      int index, {
      required VoidCallback? onView,
      required VoidCallback? onShare,
      required VoidCallback? onRemove,
    });

/// Визуальные настройки списка файлов.
class AppFileListStyle {
  const AppFileListStyle({
    this.tilePadding = const EdgeInsets.symmetric(
      horizontal: ThemeBuilder.defaultPadding,
      vertical: 8,
    ),
    this.dividerColor = AppColors.divider,
    this.iconColor = AppColors.primaryColor,
    this.subtitleStyle,
  });

  final EdgeInsets tilePadding;
  final Color dividerColor;
  final Color iconColor;
  final TextStyle? subtitleStyle;
}

/// Список файлов с просмотром, шарингом и удалением.
class AppFileListView extends StatelessWidget {
  const AppFileListView({
    super.key,
    required this.files,
    this.onChanged,
    this.editable = false,
    this.style = const AppFileListStyle(),
    this.emptyBuilder,
    this.tileBuilder,
    this.allowShare = true,
    this.allowView = true,
    this.separatorBuilder,
  });

  final List<AppFileItem> files;
  final ValueChanged<List<AppFileItem>>? onChanged;
  final bool editable;
  final AppFileListStyle style;
  final WidgetBuilder? emptyBuilder;
  final AppFileListTileBuilder? tileBuilder;
  final bool allowShare;
  final bool allowView;
  final IndexedWidgetBuilder? separatorBuilder;

  @override
  Widget build(BuildContext context) {
    if (files.isEmpty) {
      return emptyBuilder?.call(context) ??
          const Center(child: Text('Файлы не выбраны'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: files.length,
      separatorBuilder:
          separatorBuilder ??
          (_, __) => Divider(height: 1, color: style.dividerColor),
      itemBuilder: (context, index) {
        final file = files[index];
        return tileBuilder?.call(
              context,
              file,
              index,
              onView: allowView
                  ? () => AppFileViewer.open(context, item: file)
                  : null,
              onShare: allowShare && file.hasLocalSource
                  ? () => AppShare.shareFiles(
                      paths: [file.resolvedPath!],
                      text: file.name,
                    )
                  : null,
              onRemove: editable && onChanged != null
                  ? () => _removeAt(index)
                  : null,
            ) ??
            _DefaultFileTile(
              file: file,
              style: style,
              onView: allowView
                  ? () => AppFileViewer.open(context, item: file)
                  : null,
              onShare: allowShare && file.hasLocalSource
                  ? () => AppShare.shareFiles(
                      paths: [file.resolvedPath!],
                      text: file.name,
                    )
                  : null,
              onRemove: editable && onChanged != null
                  ? () => _removeAt(index)
                  : null,
            );
      },
    );
  }

  void _removeAt(int index) {
    if (onChanged == null) {
      return;
    }
    final next = List<AppFileItem>.from(files)..removeAt(index);
    onChanged!(next);
  }
}

class _DefaultFileTile extends StatelessWidget {
  const _DefaultFileTile({
    required this.file,
    required this.style,
    this.onView,
    this.onShare,
    this.onRemove,
  });

  final AppFileItem file;
  final AppFileListStyle style;
  final VoidCallback? onView;
  final VoidCallback? onShare;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (file.mimeType != null) file.mimeType,
      AppFileUtils.formatFileSize(file.sizeBytes),
    ].where((part) => part != null && part.isNotEmpty).join(' • ');

    return ListTile(
      contentPadding: style.tilePadding,
      leading: Icon(_iconForFile(file), color: style.iconColor),
      title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle.isEmpty
          ? null
          : Text(
              subtitle,
              style: style.subtitleStyle ?? AppTextStyle.small,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      onTap: onView,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onShare != null)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: onShare,
            ),
          if (onRemove != null)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onRemove,
            ),
        ],
      ),
    );
  }

  IconData _iconForFile(AppFileItem file) {
    final mime = file.mimeType;
    final path = file.resolvedPath;
    if (AppFileUtils.isImageMime(mime) ||
        (path != null && AppFileUtils.isImagePath(path))) {
      return Icons.image_outlined;
    }
    if (AppFileUtils.isVideoMime(mime) ||
        (path != null && AppFileUtils.isVideoPath(path))) {
      return Icons.videocam_outlined;
    }
    if (AppFileUtils.isAudioMime(mime) ||
        (path != null && AppFileUtils.isAudioPath(path))) {
      return Icons.audiotrack_outlined;
    }
    if (AppFileUtils.isPdfMime(mime) ||
        (path != null && AppFileUtils.isPdfPath(path))) {
      return Icons.picture_as_pdf_outlined;
    }
    return Icons.insert_drive_file_outlined;
  }
}
