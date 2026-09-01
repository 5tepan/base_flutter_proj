import 'package:base_flutter_proj/core/assets/app_asset.dart';
import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Предзагрузка локальных ассетов для стабильной вёрстки и быстрого первого кадра.
abstract final class AppAssetsPreloader {
  static bool _rastersPrecached = false;

  /// SVG без [BuildContext] — вызывать из [AppBootstrap.initialize].
  static Future<void> preloadVectors({
    Iterable<AppAsset> assets = AppAssets.preloadable,
  }) async {
    final loaders = assets.where((asset) => asset.isVector).map(
      (asset) async {
        try {
          final loader = SvgAssetLoader(asset.path);
          await svg.cache.putIfAbsent(
            loader.cacheKey(null),
            () => loader.loadBytes(null),
          );
        } catch (_) {}
      },
    );

    await Future.wait(loaders);
  }

  /// PNG — один раз после появления [BuildContext] (например в [AppAssetsWarmup]).
  static Future<void> precacheRasters(
    BuildContext context, {
    Iterable<AppAsset> assets = AppAssets.preloadable,
  }) async {
    if (_rastersPrecached) {
      return;
    }
    _rastersPrecached = true;

    await Future.wait(
      assets.where((asset) => asset.isRaster).map((asset) async {
        try {
          await precacheImage(AssetImage(asset.path), context);
        } catch (_) {}
      }),
    );
  }
}

/// Обёртка: precache raster-ассетов на первом кадре.
class AppAssetsWarmup extends StatefulWidget {
  const AppAssetsWarmup({required this.child, super.key});

  final Widget child;

  @override
  State<AppAssetsWarmup> createState() => _AppAssetsWarmupState();
}

class _AppAssetsWarmupState extends State<AppAssetsWarmup> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      AppAssetsPreloader.precacheRasters(context);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
