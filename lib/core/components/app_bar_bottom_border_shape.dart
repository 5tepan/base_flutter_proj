import 'package:flutter/material.dart';

class AppBarBottomBorderShape extends ContinuousRectangleBorder {
  final double radius;
  final Color borderColor;
  final double borderWidth;

  const AppBarBottomBorderShape({
    required this.radius,
    required this.borderColor,
    this.borderWidth = 1,
  });

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(
      RRect.fromRectAndCorners(
        rect,
        bottomLeft: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final half = borderWidth / 2;
    final left = rect.left + half;
    final right = rect.right - half;
    final bottom = rect.bottom - half;
    final r = radius;

    final path = Path()
      ..moveTo(left, bottom - r)
      ..arcToPoint(
        Offset(left + r, bottom),
        radius: Radius.circular(r),
        clockwise: false,
      )
      ..lineTo(right - r, bottom)
      ..arcToPoint(
        Offset(right, bottom - r),
        radius: Radius.circular(r),
        clockwise: false,
      );

    canvas.drawPath(path, paint);
  }
}
