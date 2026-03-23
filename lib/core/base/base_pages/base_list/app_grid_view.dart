import 'package:base_flutter_proj/core/base/base_pages/base_list/grid_layout_delegate.dart';
import 'package:flutter/material.dart';

class AppGridView<T> extends StatelessWidget {
  const AppGridView({
    required this.items,
    required this.itemBuilder,
    required this.layout,
    super.key,
    this.onItemTap,
    this.onRefresh,
    this.padding = EdgeInsets.zero,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(BuildContext context, T item, int index)? onItemTap;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry padding;
  final GridLayoutDelegate layout;

  @override
  Widget build(BuildContext context) {
    Widget grid = GridView.builder(
      padding: padding,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: layout.axisCount,
        mainAxisSpacing: layout.mainAxisSpacing,
        crossAxisSpacing: layout.crossAxisSpacing,
        childAspectRatio: layout.childAspectRatio,
      ),
      itemBuilder: (context, index) {
        Widget child = itemBuilder(context, items[index], index);

        if (onItemTap != null) {
          child = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onItemTap!(context, items[index], index),
            child: child,
          );
        }

        return child;
      },
    );

    if (onRefresh != null) {
      grid = RefreshIndicator(onRefresh: onRefresh!, child: grid);
    }

    return grid;
  }
}
