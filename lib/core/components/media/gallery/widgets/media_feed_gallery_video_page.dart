import 'dart:async';

import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaFeedGalleryVideoPage extends StatefulWidget {
  const MediaFeedGalleryVideoPage({
    super.key,
    required this.isActive,
    required this.controller,
    required this.isInitialized,
  });

  final bool isActive;
  final VideoPlayerController? controller;
  final bool isInitialized;

  @override
  State<MediaFeedGalleryVideoPage> createState() =>
      _MediaFeedGalleryVideoPageState();
}

class _MediaFeedGalleryVideoPageState extends State<MediaFeedGalleryVideoPage> {
  VideoPlayerController? _listenedController;

  @override
  void initState() {
    super.initState();
    _attachListener(widget.controller);
  }

  @override
  void didUpdateWidget(covariant MediaFeedGalleryVideoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detachListener();
      _attachListener(widget.controller);
    }
  }

  @override
  void dispose() {
    _detachListener();
    super.dispose();
  }

  void _attachListener(VideoPlayerController? controller) {
    _listenedController = controller;
    controller?.addListener(_onVideoTick);
  }

  void _detachListener() {
    _listenedController?.removeListener(_onVideoTick);
    _listenedController = null;
  }

  void _onVideoTick() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive || widget.controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }

    if (!widget.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.white),
      );
    }

    final controller = widget.controller!;

    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          unawaited(controller.pause());
        } else {
          unawaited(controller.play());
        }
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: [
              VideoPlayer(controller),
              if (!controller.value.isPlaying)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.35),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(16),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.white,
                    size: 48,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
