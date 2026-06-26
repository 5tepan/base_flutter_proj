import 'package:base_flutter_proj/core/base/base_pages/pagination/grid_layout_delegate.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_scroll_view.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:flutter/material.dart';

/// Сетка с пагинацией — тот же паттерн load more, что у [PaginatedListView].
///
/// Scroll-header/footer: [header], [footer].
/// Fixed header/footer: оберните в [PaginatedListFrame].
class PaginatedGridView<T> extends StatelessWidget {
  const PaginatedGridView({
    required this.state,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    super.key,
    this.header,
    this.footer,
    this.empty,
    this.layout = const GridLayoutDelegate(),
    this.padding = EdgeInsets.zero,
    this.loadMoreThreshold = 200,
  });

  final PaginatedState<T> state;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final VoidCallback onRetry;
  final Widget? header;
  final Widget? footer;
  final Widget? empty;
  final GridLayoutDelegate layout;
  final EdgeInsetsGeometry padding;
  final double loadMoreThreshold;

  @override
  Widget build(BuildContext context) {
    return PaginatedScrollView<T>(
      state: state,
      onRefresh: onRefresh,
      onLoadMore: onLoadMore,
      onRetry: onRetry,
      empty: empty,
      loadMoreThreshold: loadMoreThreshold,
      builder: (context, physics) {
        final itemCount = state.items.length + (state.isLoadingMore ? 1 : 0);

        if (header == null && footer == null) {
          return GridView.builder(
            physics: physics,
            padding: padding,
            gridDelegate: layout.toGridDelegate(),
            itemCount: itemCount,
            itemBuilder: _buildItem,
          );
        }

        return CustomScrollView(
          physics: physics,
          slivers: [
            if (header != null) SliverToBoxAdapter(child: header),
            SliverPadding(
              padding: padding,
              sliver: SliverGrid(
                gridDelegate: layout.toGridDelegate(),
                delegate: SliverChildBuilderDelegate(
                  _buildItem,
                  childCount: itemCount,
                ),
              ),
            ),
            if (footer != null) SliverToBoxAdapter(child: footer),
          ],
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    if (index >= state.items.length) {
      return const Center(child: AppLoadingIndicator());
    }
    return itemBuilder(context, state.items[index], index);
  }
}
