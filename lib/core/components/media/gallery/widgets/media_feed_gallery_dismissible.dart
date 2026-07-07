import 'package:flutter/material.dart';

/// Вертикальный свайп (вверх или вниз) для закрытия полноэкранной галереи.
class MediaFeedGalleryDismissible extends StatefulWidget {
  const MediaFeedGalleryDismissible({
    super.key,
    required this.child,
    required this.onDismiss,
    this.dismissDistance = 96,
    this.dismissVelocity = 420,
  });

  final Widget child;
  final VoidCallback onDismiss;
  final double dismissDistance;
  final double dismissVelocity;

  @override
  State<MediaFeedGalleryDismissible> createState() =>
      _MediaFeedGalleryDismissibleState();
}

class _MediaFeedGalleryDismissibleState extends State<MediaFeedGalleryDismissible> {
  double _dragOffset = 0;

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() => _dragOffset += details.delta.dy);
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    final shouldDismiss =
        _dragOffset.abs() >= widget.dismissDistance ||
        velocity.abs() >= widget.dismissVelocity;

    if (shouldDismiss) {
      widget.onDismiss();
      return;
    }

    setState(() => _dragOffset = 0);
  }

  @override
  Widget build(BuildContext context) {
    final opacity = (1 - (_dragOffset.abs() / 320)).clamp(0.35, 1.0).toDouble();

    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      behavior: HitTestBehavior.translucent,
      child: Transform.translate(
        offset: Offset(0, _dragOffset),
        child: Opacity(opacity: opacity, child: widget.child),
      ),
    );
  }
}
