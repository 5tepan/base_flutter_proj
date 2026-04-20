import 'package:base_flutter_proj/core/base/model/entities/file/custom_file.dart';
import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:base_flutter_proj/core/helpers/picture_cache_helper.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String placeholder;
  final String? blurHash;
  final int? decodingWidth;
  final int? decodingHeight;

  final CustomFile? image;

  final BoxFit fit;
  final BoxFit placeholderFit;
  final bool needPlaceholder;

  final Color? color;

  const SafeNetworkImage({
    super.key,
    this.imageUrl,
    this.placeholder = AssetsCatalog.placeholder,
    this.fit = BoxFit.cover,
    this.placeholderFit = BoxFit.cover,
    this.needPlaceholder = true,
    this.color,
  }) : image = null,
       blurHash = null,
       decodingWidth = null,
       decodingHeight = null;

  SafeNetworkImage.customFile({
    required this.image,
    super.key,
    this.placeholder = AssetsCatalog.placeholder,
    this.fit = BoxFit.cover,
    this.placeholderFit = BoxFit.cover,
    this.needPlaceholder = true,
    this.decodingWidth,
    this.decodingHeight,
    this.color,
  }) : imageUrl = image?.displayUrl,
       blurHash = image?.blurHash;

  bool get isSvg => PictureCacheHelper.isSvg(imageUrl);

  @override
  Widget build(BuildContext context) {
    if (imageUrl?.isEmpty ?? true) {
      return _buildPlaceholder(context);
    }

    if (isSvg) {
      return _buildSvgImage(context);
    }

    return ExtendedImage.network(
      imageUrl ?? '',
      fit: fit,
      color: color,
      loadStateChanged: onLoadStateChanged,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return needPlaceholder
        ? Image.asset(
            placeholder,
            fit: placeholderFit,
            colorBlendMode: BlendMode.color,
          )
        : const SizedBox.shrink();
  }

  Widget _buildSvgImage(BuildContext context) {
    return SvgPicture.network(
      imageUrl ?? '',
      fit: fit,
      placeholderBuilder: _buildPlaceholder,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }

  Widget? onLoadStateChanged(ExtendedImageState state) {
    if (state.extendedImageLoadState == LoadState.completed) {
      return null;
    }
    if (blurHash?.isNotEmpty ?? false) {
      return BlurHash(
        hash: blurHash!,
        decodingWidth: decodingWidth ?? image?.width ?? 32,
        decodingHeight: decodingHeight ?? image?.height ?? 32,
      );
    }
    return Image.asset(placeholder, fit: placeholderFit);
  }
}
