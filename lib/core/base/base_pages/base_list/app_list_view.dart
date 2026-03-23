import 'package:flutter/material.dart';

class AppListView<T> extends StatelessWidget {
  const AppListView({
    required this.items,
    required this.itemBuilder,
    super.key,
    this.onItemTap,
    this.onRefresh,
    this.separatorBuilder,
    this.padding = EdgeInsets.zero,
    this.reverse = false,
    this.shrinkWrap = false,
    this.primary = true,
    this.scrollController,
    this.header,
    this.footer,
    this.fixedHeader,
    this.fixedFooter,
    this.showRefreshIndicator = true,
    this.physics = const AlwaysScrollableScrollPhysics(),
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(BuildContext context, T item, int index)? onItemTap;
  final Future<void> Function()? onRefresh;
  final Widget Function(BuildContext context, int index)? separatorBuilder;
  final EdgeInsetsGeometry padding;
  final bool reverse;
  final bool shrinkWrap;
  final bool primary;
  final ScrollController? scrollController;
  final Widget? header;
  final Widget? footer;
  final Widget? fixedHeader;
  final Widget? fixedFooter;
  final bool showRefreshIndicator;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    final hasHeader = header != null;
    final hasFooter = footer != null;
    final totalCount = items.length + (hasHeader ? 1 : 0) + (hasFooter ? 1 : 0);

    Widget list = Column(
      children: [
        if (fixedHeader != null) fixedHeader!,
        Expanded(
          child: ListView.separated(
            controller: primary ? null : scrollController,
            primary: primary,
            reverse: reverse,
            shrinkWrap: shrinkWrap,
            physics: physics,
            padding: padding,
            itemCount: totalCount,
            itemBuilder: (context, index) {
              if (hasHeader && index == 0) {
                return header!;
              }

              final itemIndex = hasHeader ? index - 1 : index;

              if (hasFooter && itemIndex == items.length) {
                return footer!;
              }

              Widget child = itemBuilder(context, items[itemIndex], itemIndex);

              if (onItemTap != null) {
                child = GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onItemTap!(context, items[itemIndex], itemIndex),
                  child: child,
                );
              }

              return child;
            },
            separatorBuilder: (context, index) {
              if (separatorBuilder != null) {
                return separatorBuilder!(context, index);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        if (fixedFooter != null) fixedFooter!,
      ],
    );

    if (showRefreshIndicator && onRefresh != null) {
      list = RefreshIndicator(onRefresh: onRefresh!, child: list);
    }

    return list;
  }
}
