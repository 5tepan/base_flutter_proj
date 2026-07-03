import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:base_flutter_proj/core/components/files/app_file_item.dart';
import 'package:base_flutter_proj/core/components/files/app_file_storage.dart';
import 'package:base_flutter_proj/core/components/files/app_file_utils.dart';
import 'package:base_flutter_proj/core/components/media/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:open_filex/open_filex.dart';
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
      name: path != null ? AppFileUtils.fileNameFromPath(path) : 'media',
      localPath: path,
      remoteUrl: item.remoteUrl,
      localFile: item.localFile,
      mimeType: path == null
          ? null
          : AppFileUtils.guessMimeType(path: path),
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
  }) async {
    final path = item.resolvedPath;
    if (path != null && path.isNotEmpty) {
      return OpenFilex.open(path);
    }
    return OpenResult(
      type: ResultType.error,
      message: unavailableMessage ?? 'Local file unavailable',
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
          if (widget.allowShare && path != null)
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => AppShare.shareFiles(paths: [path]),
            ),
          if (widget.allowSaveToDownloads && path != null)
            IconButton(
              icon: const Icon(Icons.download_outlined),
              onPressed: () => _saveToDownloads(path),
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
    if (path != null) {
      if (AppFileUtils.isImageMime(mime) || AppFileUtils.isImagePath(path)) {
        return InteractiveViewer(child: Image.file(File(path), fit: BoxFit.contain));
      }
      if (AppFileUtils.isVideoMime(mime) || AppFileUtils.isVideoPath(path)) {
        return _VideoPreview(path: path);
      }
      if (AppFileUtils.isAudioMime(mime) || AppFileUtils.isAudioPath(path)) {
        return _AudioPreview(path: path, title: widget.item.name);
      }
      if (AppFileUtils.isPdfMime(mime) || AppFileUtils.isPdfPath(path)) {
        return PDFView(filePath: path);
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.message)),
      );
    }
  }

  Future<void> _saveToDownloads(String path) async {
    final l10n = S.of(context);
    final savedPath = await AppFileStorage.copyToDownloads(
      sourcePath: path,
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
  const _VideoPreview({required this.path});

  final String path;

  @override
  State<_VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<_VideoPreview> {
  late final VideoPlayerController _controller;
  var _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.path))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
        }
      }).catchError((Object error) {
        CustomLogger.warning('Video init failed: $error');
      });
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),
            IconButton(
              iconSize: 56,
              color: AppColors.white,
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              onPressed: () {
                setState(() {
                  if (_controller.value.isPlaying) {
                    _controller.pause();
                  } else {
                    _controller.play();
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

class _AudioPreview extends StatefulWidget {
  const _AudioPreview({
    required this.path,
    required this.title,
  });

  final String path;
  final String title;

  @override
  State<_AudioPreview> createState() => _AudioPreviewState();
}

class _AudioPreviewState extends State<_AudioPreview> {
  final AudioPlayer _player = AudioPlayer();
  var _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    unawaited(_player.setSource(DeviceFileSource(widget.path)));
    _player.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() => _duration = duration);
      }
    });
    _player.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() => _position = position);
      }
    });
    _player.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.audiotrack, size: 72, color: AppColors.primaryColor),
            const SizedBox(height: 16),
            Text(widget.title, style: AppTextStyle.title, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            Slider(
              value: _duration.inMilliseconds == 0
                  ? 0
                  : _position.inMilliseconds / _duration.inMilliseconds,
              onChanged: _duration.inMilliseconds == 0
                  ? null
                  : (value) {
                      final target = Duration(
                        milliseconds: (_duration.inMilliseconds * value).round(),
                      );
                      unawaited(_player.seek(target));
                    },
            ),
            Text('${_format(_position)} / ${_format(_duration)}'),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _togglePlayback,
              icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(_isPlaying ? l10n.fileAudioPause : l10n.fileAudioPlay),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    if (mounted) {
      setState(() => _isPlaying = !_isPlaying);
    }
  }

  String _format(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
