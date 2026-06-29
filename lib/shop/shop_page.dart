import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/grid_layout_delegate.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_grid_view.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_list_layout.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_list_view.dart';
import 'package:base_flutter_proj/core/components/empty_state_widget.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/shop/entities/product.dart';
import 'package:base_flutter_proj/shop/providers/shop_list_notifier.dart';
import 'package:base_flutter_proj/shop/view/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ShopLayoutMode { list, grid }

Widget _shopListSeparator(BuildContext context, int index) {
  return PaginatedSeparator.divider();
}

/// Эталонный экран списка: Repository → PaginatedNotifier → List/Grid.
class ShopPage extends ConsumerStatefulWidget {
  const ShopPage({super.key});

  @override
  ConsumerState<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends ConsumerState<ShopPage> {
  ShopLayoutMode _layoutMode = ShopLayoutMode.list;

  static const _listLayout = PaginatedListLayout(
    separatorBuilder: _shopListSeparator,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final listState = ref.watch(shopListProvider);
    final notifier = ref.read(shopListProvider.notifier);

    final empty = EmptyStateWidget(
      title: l10n.shopEmptyTitle,
      subtitle: l10n.shopEmptySubtitle,
      icon: Icons.shopping_bag_outlined,
    );

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(
        title: l10n.shopTitle,
        actionsWidget: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SegmentedButton<ShopLayoutMode>(
              segments: [
                ButtonSegment(
                  value: ShopLayoutMode.list,
                  icon: const Icon(Icons.view_list),
                  label: Text(l10n.shopLayoutList),
                ),
                ButtonSegment(
                  value: ShopLayoutMode.grid,
                  icon: const Icon(Icons.grid_view),
                  label: Text(l10n.shopLayoutGrid),
                ),
              ],
              selected: {_layoutMode},
              onSelectionChanged: (selection) {
                setState(() => _layoutMode = selection.first);
              },
            ),
          ),
        ],
      ),
      body: switch (_layoutMode) {
        ShopLayoutMode.list => PaginatedListView<Product>(
            state: listState,
            listLayout: _listLayout,
            onRefresh: notifier.reload,
            onLoadMore: notifier.loadMore,
            onRetry: notifier.loadInitial,
            empty: empty,
            itemBuilder: (context, product, index) =>
                ProductListTile(product: product),
          ),
        ShopLayoutMode.grid => PaginatedGridView<Product>(
            state: listState,
            onRefresh: notifier.reload,
            onLoadMore: notifier.loadMore,
            onRetry: notifier.loadInitial,
            empty: empty,
            gridLayout: const GridLayoutDelegate(childAspectRatio: 0.85),
            itemBuilder: (context, product, index) =>
                ProductGridTile(product: product),
          ),
      },
    );
  }
}
