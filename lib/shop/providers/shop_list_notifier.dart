import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_notifier.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/shop/model/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Публичный контракт notifier списка (аналог IWidgetModel в Elementary).
abstract class ShopListActions {
  Future<void> reload();
  Future<void> loadMore();
  void clearError();
}

class ShopListNotifier extends PaginatedNotifier<Product>
    implements ShopListActions {
  static const int _totalMockItems = 45;

  @override
  int get pageSize => 20;

  @override
  Future<List<Product>> loadPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final start = page * pageSize;
    if (start >= _totalMockItems) {
      return [];
    }

    final count = (start + pageSize > _totalMockItems)
        ? _totalMockItems - start
        : pageSize;

    return List.generate(
      count,
      (index) => Product(
        id: 'product_${start + index}',
        name: 'Product ${start + index + 1}',
      ),
    );
  }
}

final shopListProvider =
    NotifierProvider<ShopListNotifier, PaginatedState<Product>>(
  ShopListNotifier.new,
);
