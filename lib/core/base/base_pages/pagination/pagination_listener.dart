import 'package:base_flutter_proj/core/base/base_pages/pagination/pagination_controller.dart';
import 'package:flutter/widgets.dart';

class PaginationListener extends StatelessWidget {
  const PaginationListener({
    required this.index,
    required this.itemsLength,
    required this.isAllLoaded,
    required this.isLoading,
    required this.isLoadingMore,
    required this.onLoadMore,
    required this.child,
    super.key,
    this.controller = const PaginationController(),
  });

  final int index;
  final int itemsLength;
  final bool isAllLoaded;
  final bool isLoading;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;
  final Widget child;
  final PaginationController controller;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.shouldLoadMore(
        renderedItemIndex: index,
        itemsLength: itemsLength,
        isAllLoaded: isAllLoaded,
        isLoadingMore: isLoadingMore,
        isLoading: isLoading,
      )) {
        onLoadMore();
      }
    });

    return child;
  }
}
