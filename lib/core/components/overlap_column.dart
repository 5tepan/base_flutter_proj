import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OverlapColumn extends MultiChildRenderObjectWidget {
  final double overlap;
  final bool stretch;
  final AlignmentGeometry alignment;
  final Clip clipBehavior;

  const OverlapColumn({
    required super.children,
    super.key,
    this.overlap = 7,
    this.stretch = true,
    this.alignment = Alignment.topLeft,
    this.clipBehavior = Clip.none,
  }) : assert(overlap >= 0);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderOverlapColumn(
      overlap: overlap,
      stretch: stretch,
      alignment: alignment,
      textDirection: Directionality.of(context),
      clipBehavior: clipBehavior,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderOverlapColumn renderObject,
  ) {
    renderObject
      ..overlap = overlap
      ..stretch = stretch
      ..alignment = alignment
      ..textDirection = Directionality.of(context)
      ..clipBehavior = clipBehavior;
  }
}

class _OverlapColumnParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderOverlapColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _OverlapColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _OverlapColumnParentData> {
  _RenderOverlapColumn({
    required double overlap,
    required bool stretch,
    required AlignmentGeometry alignment,
    required TextDirection textDirection,
    required Clip clipBehavior,
  }) : _overlap = overlap,
       _stretch = stretch,
       _alignment = alignment,
       _textDirection = textDirection,
       _clipBehavior = clipBehavior;

  double _overlap;
  bool _stretch;
  AlignmentGeometry _alignment;
  TextDirection _textDirection;
  Clip _clipBehavior;
  late Alignment _resolvedAlignment;

  double get overlap => _overlap;
  set overlap(double value) {
    if (_overlap == value) return;
    _overlap = value;
    markNeedsLayout();
  }

  bool get stretch => _stretch;
  set stretch(bool value) {
    if (_stretch == value) return;
    _stretch = value;
    markNeedsLayout();
  }

  AlignmentGeometry get alignment => _alignment;
  set alignment(AlignmentGeometry value) {
    if (_alignment == value) return;
    _alignment = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  Clip get clipBehavior => _clipBehavior;
  set clipBehavior(Clip value) {
    if (_clipBehavior == value) return;
    _clipBehavior = value;
    markNeedsPaint();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _OverlapColumnParentData) {
      child.parentData = _OverlapColumnParentData();
    }
  }

  @override
  void performLayout() {
    _resolvedAlignment = _alignment.resolve(_textDirection);

    if (firstChild == null) {
      size = constraints.constrain(Size(constraints.minWidth, 0));
      return;
    }

    final hasBoundedWidth = constraints.maxWidth.isFinite;
    final childConstraints = stretch && hasBoundedWidth
        ? BoxConstraints(
            minWidth: constraints.maxWidth,
            maxWidth: constraints.maxWidth,
          )
        : BoxConstraints(maxWidth: constraints.maxWidth);

    double maxChildWidth = 0;
    double totalHeight = 0;
    var index = 0;
    var child = firstChild;
    while (child != null) {
      child.layout(childConstraints, parentUsesSize: true);
      maxChildWidth = math.max(maxChildWidth, child.size.width);
      totalHeight += child.size.height;
      if (index > 0) {
        totalHeight -= overlap;
      }
      index++;
      final childParentData = child.parentData! as _OverlapColumnParentData;
      child = childParentData.nextSibling;
    }

    final finalWidth = stretch && hasBoundedWidth
        ? constraints.maxWidth
        : maxChildWidth;
    size = constraints.constrain(Size(finalWidth, totalHeight));

    double dy = 0;
    child = firstChild;
    while (child != null) {
      final childParentData = child.parentData! as _OverlapColumnParentData;
      final dx = _resolvedAlignment
          .alongOffset(Offset(size.width - child.size.width, 0))
          .dx;
      childParentData.offset = Offset(dx, dy);
      dy += child.size.height - overlap;
      child = childParentData.nextSibling;
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (clipBehavior == Clip.none) {
      defaultPaint(context, offset);
      return;
    }

    context.pushClipRect(
      needsCompositing,
      offset,
      offset & size,
      defaultPaint,
      clipBehavior: clipBehavior,
    );
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
