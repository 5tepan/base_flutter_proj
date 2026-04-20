import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class PictureCacheHelper {
  static bool isSvg(String? url) =>
      url?.toLowerCase().endsWith('.svg') ?? false;

  static Future<void> preloadSvgList(
    BuildContext context,
    Iterable<String> urls,
  ) async {
    final uniqueUrls = urls.toSet();
    await Future.wait(
      uniqueUrls.map((url) async {
        try {
          final loader = SvgNetworkLoader(url);
          await svg.cache.putIfAbsent(
            loader.cacheKey(context),
            () => loader.loadBytes(context),
          );
        } catch (_) {}
      }),
    );
  }

  static Future<void> preloadImages(
    BuildContext context,
    Iterable<String> urls,
  ) async {
    final uniqueUrls = urls.toSet();
    await Future.wait(
      uniqueUrls.map((url) async {
        try {
          final provider = ExtendedNetworkImageProvider(url, cache: true);
          await precacheImage(provider, context);
        } catch (_) {}
      }),
    );
  }

  static Future<void> preloadAll(
    BuildContext context, {
    Iterable<String> urls = const [],
    Iterable<String>? svgUrls,
    Iterable<String>? imageUrls,
  }) async {
    final svgList = svgUrls ?? urls.where(isSvg);
    final imageList = imageUrls ?? urls.where((url) => !isSvg(url));

    await Future.wait([
      preloadSvgList(context, svgList),
      preloadImages(context, imageList),
    ]);
  }
}
