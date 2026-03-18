import 'package:flutter/material.dart';

mixin DebugBannerMixin {
  Widget decorateWithBanner({
    required MaterialApp child,
    required String? version,
    required VoidCallback onBannerClick,
  }) {
    if (version == null) {
      return child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Banner(
            location: BannerLocation.bottomEnd,
            message: 'DEV: $version',
            layoutDirection: TextDirection.ltr,
            textDirection: TextDirection.ltr,
            child: child,
          ),
          _buildLogTapZone(onBannerClick),
        ],
      ),
    );
  }

  Widget _buildLogTapZone(VoidCallback onBannerClick) {
    return ClipPath(
      clipper: _TriangleClipper(),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onDoubleTap: onBannerClick,
        child: const SizedBox(width: 60, height: 60),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TriangleClipper oldClipper) => false;
}
