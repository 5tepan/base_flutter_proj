import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_list_layout.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_scroll_view.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Список с пагинацией, pull-to-refresh и обработкой состояний [PaginatedState].
///
/// Scroll-header/footer: [header], [footer].
/// Fixed header/footer: [PaginatedListFrame].
/// Разделители: [listLayout].
class PaginatedListView<T> extends StatelessWidget {
  const PaginatedListView({
    required this.state,
    required this.itemBuilder,
    required this.onRefresh,
    required this.onLoadMore,
    required this.onRetry,
    super.key,
    this.listLayout = const PaginatedListLayout(),
    this.header,
    this.footer,
    this.empty,
    this.loadMoreThreshold = 200,
  });

  final PaginatedState<T> state;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoadMore;
  final VoidCallback onRetry;
  final PaginatedListLayout listLayout;
  final Widget? header;
  final Widget? footer;
  final Widget? empty;
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
          return ListView.builder(
            physics: physics,
            itemCount: itemCount,
            itemBuilder: _buildItem,
          );
        }

        return CustomScrollView(
          physics: physics,
          slivers: [
            if (header != null) SliverToBoxAdapter(child: header),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                _buildItem,
                childCount: itemCount,
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
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: ThemeBuilder.defaultPadding),
        child: Center(child: AppLoadingIndicator()),
      );
    }

    final item = itemBuilder(context, state.items[index], index);
    final separatorBuilder = listLayout.separatorBuilder;
    if (separatorBuilder == null) {
      return item;
    }

    final isLast = index == state.items.length - 1;
    if (isLast && !listLayout.showSeparatorAfterLastItem) {
      return item;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        item,
        separatorBuilder(context, index),
      ],
    );
  }
}
