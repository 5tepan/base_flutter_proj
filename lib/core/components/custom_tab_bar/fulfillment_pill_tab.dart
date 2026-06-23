import 'package:base_flutter_proj/core/components/custom_tab_bar/fulfillment_segment_tab.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

class FulfillmentPillTab extends StatelessWidget {
  final TabController controller;
  final int index;
  final FulfillmentSegmentTab tab;
  final FulfillmentSegmentTabsStyle style;
  final double? height;
  final double leadingGap;
  final double trailingGap;

  const FulfillmentPillTab({
    required this.controller,
    required this.index,
    required this.tab,
    required this.style,
    this.height,
    this.leadingGap = 0,
    this.trailingGap = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        final selected = controller.index == index;
        return Padding(
          padding: EdgeInsets.only(left: leadingGap, right: trailingGap),
          child: Container(
            width: double.infinity,
            height: height,
            padding: style.contentPadding,
            decoration: BoxDecoration(
              color: selected
                  ? style.selectedFillColor
                  : style.unselectedFillColor,
              borderRadius: BorderRadius.circular(style.pillBorderRadius),
              border: Border.all(
                color: selected
                    ? style.selectedBorderColor
                    : style.unselectedBorderColor,
                width: style.borderWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: height != null
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                Text(
                  tab.title,
                  style: style.resolvedTitleStyle(
                    tabTitleStyle: tab.titleStyle,
                  ),
                ),
                SizedBox(height: style.titleSubtitleSpacing),
                Text(
                  tab.subtitle,
                  style: style.resolvedSubtitleStyle(
                    tabSubtitleStyle: tab.subtitleStyle,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
