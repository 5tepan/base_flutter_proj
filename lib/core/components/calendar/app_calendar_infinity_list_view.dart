import 'package:flutter/material.dart';

class AppCalendarInfinityListView extends StatelessWidget {
  const AppCalendarInfinityListView.separated({
    super.key,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.anchor = 0,
    this.reverse = false,
    this.minIndex,
    this.maxIndex,
    this.padding = EdgeInsets.zero,
  });

  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int? index) separatorBuilder;
  final double anchor;
  final bool reverse;
  final int? minIndex;
  final int? maxIndex;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final center = UniqueKey();

    return CustomScrollView(
      anchor: anchor,
      center: center,
      reverse: reverse,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.only(
            top: padding.top,
            left: padding.left,
            right: padding.right,
          ),
          sliver: SliverMainAxisGroup(
            slivers: [
              _InfiniteSliverSeparated(
                isNegative: true,
                itemBuilder: itemBuilder,
                separatorBuilder: separatorBuilder,
                itemCount: minIndex,
              ),
              SliverToBoxAdapter(child: separatorBuilder(context, null)),
            ],
          ),
        ),
        SliverToBoxAdapter(key: center, child: const SizedBox.shrink()),
        SliverPadding(
          padding: EdgeInsets.only(
            left: padding.left,
            right: padding.right,
            bottom: padding.bottom,
          ),
          sliver: _InfiniteSliverSeparated(
            isNegative: false,
            itemBuilder: itemBuilder,
            separatorBuilder: separatorBuilder,
            itemCount: maxIndex,
          ),
        ),
      ],
    );
  }
}

class _InfiniteSliverSeparated extends StatelessWidget {
  const _InfiniteSliverSeparated({
    required this.isNegative,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.itemCount,
  });

  final bool isNegative;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final Widget Function(BuildContext context, int? index) separatorBuilder;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final actualIndex = isNegative ? -(index + 1) : index;
        return itemBuilder(context, actualIndex);
      },
      separatorBuilder: separatorBuilder,
    );
  }
}
