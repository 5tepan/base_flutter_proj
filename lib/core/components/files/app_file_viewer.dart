import 'dart:async';

import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:base_flutter_proj/core/assets/app_icon.dart';
import 'package:base_flutter_proj/core/components/files/app_file_item.dart';
import 'package:base_flutter_proj/core/components/files/app_file_image.dart';
import 'package:base_flutter_proj/core/components/files/app_file_utils.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/platform/files/app_file_opener.dart';
import 'package:base_flutter_proj/core/platform/files/app_file_storage.dart';
import 'package:base_flutter_proj/core/platform/files/app_pdf_preview.dart';
import 'package:base_flutter_proj/core/platform/media/app_audio_preview.dart';
import 'package:base_flutter_proj/core/platform/media/app_video_controller.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import 'package:video_player/video_player.dart';

/// Просмотр файлов и медиа: PDF, изображения, видео, аудио, внешние приложения.
abstract final class AppFileViewer {
  static Future<void> open(
    BuildContext context, {
    required AppFileItem item,
    bool allowShare = true,
    bool allowSaveToDownloads = true,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => _AppFileViewerPage(
          item: item,
          allowShare: allowShare,
          allowSaveToDownloads: allowSaveToDownloads,
        ),
      ),
    );
  }

  static Future<void> openMedia(
    BuildContext context, {
    required MediaFeedItem item,
    bool allowShare = true,
  }) {
    final path = item.localFile?.path;
    final fileItem = AppFileItem(
      id: item.id,
      name:
          item.localFile?.name ??
          (path != null && path.isNotEmpty
              ? AppFileUtils.fileNameFromPath(path)
              : 'media'),
      localPath: path?.isNotEmpty == true ? path : null,
      remoteUrl: item.remoteUrl,
      localFile: item.localFile,
      mimeType:
          item.localFile?.mimeType ??
          (path == null
              ? null
              : AppFileUtils.guessMimeType(
                  path: path,
                  name: item.localFile?.name,
                )),
    );

    return open(
      context,
      item: fileItem,
      allowShare: allowShare,
      allowSaveToDownloads: false,
    );
  }

  static Future<OpenResult> openExternally(
    AppFileItem item, {
    String? unavailableMessage,
  }) {
    return openAppFile(
      item.resolvedPath,
      unavailableMessage: unavailableMessage ?? 'Local file unavailable',
    );
  }
}

class _AppFileViewerPage extends StatefulWidget {
  const _AppFileViewerPage({
    required this.item,
    required this.allowShare,
    required this.allowSaveToDownloads,
  });

  final AppFileItem item;
  final bool allowShare;
  final bool allowSaveToDownloads;

  @override
  State<_AppFileViewerPage> createState() => _AppFileViewerPageState();
}

class _AppFileViewerPageState extends State<_AppFileViewerPage> {
  @override
  Widget build(BuildContext context) {
    final path = widget.item.resolvedPath;
    final mime =
        widget.item.mimeType ??
        (path == null ? null : AppFileUtils.guessMimeType(path: path));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.name),
        actions: [
          if (widget.allowShare && path?.isNotEmpty == true)
            IconButton(
              icon: const AppIcon(AppAssets.share),
              onPressed: () => AppShare.shareFiles(paths: [path!]),
            ),
          if (widget.allowSaveToDownloads &&
              (path?.isNotEmpty == true || widget.item.localFile != null))
            IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () => _saveToDownloads(path ?? ''),
            ),
          IconButton(
            icon: const Icon(Icons.open_in_new),
            onPressed: _openExternally,
          ),
        ],
      ),
      body: _buildBody(context, path: path, mime: mime),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required String? path,
    required String? mime,
  }) {
    final l10n = S.of(context);
    final localFile = widget.item.localFile;
    final hasLocalFile = path?.isNotEmpty == true || localFile != null;
    if (hasLocalFile) {
      final filePath = path?.isNotEmpty == true ? path! : localFile!.name;
      if (AppFileUtils.isImageMime(mime) ||
          AppFileUtils.isImagePath(filePath)) {
        return InteractiveViewer(
          child: AppFileImage(
            path: filePath,
            file: localFile,
            fit: BoxFit.contain,
          ),
        );
      }
      if (AppFileUtils.isVideoMime(mime) ||
          AppFileUtils.isVideoPath(filePath)) {
        return _VideoPreview(path: filePath, file: localFile);
      }
      if (AppFileUtils.isAudioMime(mime) ||
          AppFileUtils.isAudioPath(filePath)) {
        return appAudioPreview(
          path: filePath,
          file: localFile,
          title: widget.item.name,
          unavailableMessage: l10n.fileViewerPreviewUnavailable,
        );
      }
      if (AppFileUtils.isPdfMime(mime) || AppFileUtils.isPdfPath(filePath)) {
        return appPdfPreview(filePath);
      }
    }

    if (widget.item.remoteUrl?.isNotEmpty ?? false) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
          child: SelectableText(widget.item.remoteUrl!),
        ),
      );
    }

    return Center(child: Text(l10n.fileViewerPreviewUnavailable));
  }

  Future<void> _openExternally() async {
    final l10n = S.of(context);
    final result = await AppFileViewer.openExternally(
      widget.item,
      unavailableMessage: l10n.fileViewerLocalUnavailable,
    );
    if (!mounted) {
      return;
    }
    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  Future<void> _saveToDownloads(String path) async {
    final l10n = S.of(context);
    final savedPath = await AppFileStorage.copyToDownloads(
      sourcePath: path,
      sourceFile: widget.item.localFile,
      fileName: widget.item.name,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          savedPath == null
              ? l10n.fileViewerSaveFailed
              : l10n.fileViewerSaved(savedPath),
        ),
      ),
    );
  }
}

class _VideoPreview extends StatefulWidget {
  const _VideoPreview({required this.path, this.file});

  final String path;
  final XFile? file;

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  VideoPlayerController? _controller;
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final controller = await createAppVideoController(
      file: widget.file,
      path: widget.path,
    );
    if (controller == null) {
      return;
    }
    if (!mounted) {
      await controller.dispose();
      return;
    }
    _controller = controller;
    try {
      await controller.initialize();
      if (mounted) {
        setState(() => _initialized = true);
      }
    } catch (error) {
      CustomLogger.warning('Video init failed: $error');
    }
  }

  @override
  void dispose() {
    final controller = _controller;
    if (controller != null) {
      unawaited(controller.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final controller = _controller;
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Center(
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(controller),
            IconButton(
              iconSize: 56,
              color: AppColors.white,
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
