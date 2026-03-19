import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatelessWidget {
  final bool needShowOverlay;
  final EdgeInsets margin;
  final double cupertinoRadiusRadius;
  final double width;
  final double height;
  final double strokeWidth;
  final Color color;

  const AppLoadingIndicator({
    super.key,
    this.height = 40,
    this.width = 40,
    this.color = AppColors.updatingIndicatorColor,
    this.strokeWidth = 4.0,
    this.needShowOverlay = false,
    this.margin = EdgeInsets.zero,
    this.cupertinoRadiusRadius = 25,
  });

  @override
  Widget build(BuildContext context) {
    if (needShowOverlay) {
      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          buildLoader(),
          Container(
            color: AppColors.lightBlack.withValues(alpha: 0.2),
            height: double.infinity,
            width: double.infinity,
          ),
        ],
      );
    }
    return buildLoader();
  }

  Widget buildLoader() {
    if (AppPlatform.isAndroid) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: margin,
            width: width,
            height: height,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
        ],
      );
    }
    return Container(
      margin: margin,
      child: CupertinoActivityIndicator(
        radius: cupertinoRadiusRadius,
        color: color,
      ),
    );
  }
}
