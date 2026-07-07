import 'dart:async';
import 'dart:io';

import 'package:base_flutter_proj/core/components/media/gallery/widgets/media_feed_gallery_dismissible.dart';
import 'package:base_flutter_proj/core/components/media/gallery/widgets/media_feed_gallery_icon_button.dart';
import 'package:base_flutter_proj/core/components/media/gallery/widgets/media_feed_gallery_photo_page.dart';
import 'package:base_flutter_proj/core/components/media/gallery/widgets/media_feed_gallery_video_page.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MediaFeedGalleryPage extends StatefulWidget {
  const MediaFeedGalleryPage({
    super.key,
    required this.items,
    required this.initialIndex,
    required this.allowShare,
  });

  final List<MediaFeedItem> items;
  final int initialIndex;
  final bool allowShare;

  @override
  State<MediaFeedGalleryPage> createState() => _MediaFeedGalleryPageState();
}

class _MediaFeedGalleryPageState extends State<MediaFeedGalleryPage> {
  late final PageController _pageController;
  late int _currentIndex;
  VideoPlayerController? _videoController;
  var _videoInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncVideoForIndex(_currentIndex);
    });
  }

  @override
  void dispose() {
    unawaited(_disposeVideoController());
    _pageController.dispose();
    unawaited(SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final topPadding = MediaQuery.paddingOf(context).top;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final currentItem = widget.items[_currentIndex];
    final sharePath = _sharePathFor(currentItem);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          MediaFeedGalleryDismissible(
            onDismiss: _closeGallery,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.items.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                if (item.isVideo) {
                  return MediaFeedGalleryVideoPage(
                    isActive: index == _currentIndex,
                    controller: index == _currentIndex ? _videoController : null,
                    isInitialized: index == _currentIndex && _videoInitialized,
                  );
                }
                return MediaFeedGalleryPhotoPage(item: item);
              },
            ),
          ),
          Positioned(
            top: topPadding + 8,
            left: 8,
            child: MediaFeedGalleryIconButton(
              icon: Icons.close,
              tooltip: l10n.mediaFeedGalleryClose,
              onPressed: _closeGallery,
            ),
          ),
          Positioned(
            top: topPadding + 16,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Text(
                l10n.mediaFeedGalleryCounter(
                  _currentIndex + 1,
                  widget.items.length,
                ),
                textAlign: TextAlign.center,
                style: AppTextStyle.body.copyWith(color: AppColors.white),
              ),
            ),
          ),
          if (widget.allowShare && sharePath != null)
            Positioned(
              right: 16,
              bottom: bottomPadding + 16,
              child: MediaFeedGalleryIconButton(
                icon: Icons.ios_share,
                tooltip: l10n.shareButton,
                onPressed: () => AppShare.shareFiles(paths: [sharePath]),
              ),
            ),
        ],
      ),
    );
  }

  void _closeGallery() {
    Navigator.of(context).pop();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _videoInitialized = false;
    });
    unawaited(_syncVideoForIndex(index));
  }

  Future<void> _syncVideoForIndex(int index) async {
    await _disposeVideoController();

    final item = widget.items[index];
    if (!item.isVideo) {
      if (mounted) {
        setState(() => _videoInitialized = false);
      }
      return;
    }

    final controller = _createVideoController(item);
    if (controller == null) {
      return;
    }

    _videoController = controller;

    try {
      await controller.initialize();
      if (!mounted || _videoController != controller) {
        await controller.dispose();
        return;
      }
      setState(() => _videoInitialized = true);
    } catch (error) {
      CustomLogger.warning('Gallery video init failed: $error');
      if (mounted) {
        setState(() => _videoInitialized = false);
      }
    }
  }

  VideoPlayerController? _createVideoController(MediaFeedItem item) {
    final localPath = item.localFile?.path;
    if (localPath != null && localPath.isNotEmpty) {
      return VideoPlayerController.file(File(localPath));
    }

    final remoteUrl = item.remoteUrl;
    if (remoteUrl != null && remoteUrl.isNotEmpty) {
      return VideoPlayerController.networkUrl(Uri.parse(remoteUrl));
    }

    return null;
  }

  Future<void> _disposeVideoController() async {
    final controller = _videoController;
    _videoController = null;
    if (controller != null) {
      await controller.dispose();
    }
  }

  String? _sharePathFor(MediaFeedItem item) {
    final path = item.localFile?.path;
    if (path != null && path.isNotEmpty) {
      return path;
    }
    return null;
  }
}
