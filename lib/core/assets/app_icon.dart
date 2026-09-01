import 'package:base_flutter_proj/core/assets/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Локальная иконка или растровый ассет с фиксированным слотом [size].
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.asset, {
    super.key,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
    this.semanticLabel,
    this.alignment = Alignment.center,
  });

  final AppAsset asset;
  final double size;
  final Color? color;
  final BoxFit fit;
  final String? semanticLabel;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final child = asset.isVector ? _buildVector() : _buildRaster();

    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      child: SizedBox(
        width: size,
        height: size,
        child: Align(alignment: alignment, child: child),
      ),
    );
  }

  Widget _buildVector() {
    return SvgPicture.asset(
      asset.path,
      width: size,
      height: size,
      fit: fit,
      alignment: alignment,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }

  Widget _buildRaster() {
    return Image.asset(
      asset.path,
      width: size,
      height: size,
      fit: fit,
      alignment: alignment,
      color: color,
      colorBlendMode: color != null ? BlendMode.srcIn : null,
    );
  }
}
