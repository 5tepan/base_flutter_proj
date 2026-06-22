import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/empty_state_widget.dart';
import 'package:base_flutter_proj/core/components/paginated_list_view.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/shop/model/product.dart';
import 'package:base_flutter_proj/shop/providers/shop_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Эталонный экран списка: тупой UI + PaginatedListView + ShopListActions.
class ShopPage extends ConsumerWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final listState = ref.watch(shopListProvider);
    final notifier = ref.read(shopListProvider.notifier);

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: l10n.shopTitle),
      body: PaginatedListView<Product>(
        state: listState,
        onRefresh: notifier.reload,
        onLoadMore: notifier.loadMore,
        onRetry: notifier.loadInitial,
        empty: EmptyStateWidget(
          title: l10n.shopEmptyTitle,
          subtitle: l10n.shopEmptySubtitle,
          icon: Icons.shopping_bag_outlined,
        ),
        itemBuilder: (context, product, index) => _ProductTile(product: product),
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.name, style: AppTextStyle.body),
      leading: const Icon(Icons.shopping_bag_outlined),
    );
  }
}
