import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_notifier.dart';
import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/shop/entities/product.dart';
import 'package:base_flutter_proj/shop/providers/shop_providers.dart';
import 'package:base_flutter_proj/shop/repository/shop_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Публичный контракт notifier списка (аналог IWidgetModel в Elementary).
abstract class ShopListActions {
  Future<void> reload();
  Future<void> loadMore();
  void clearError();
}

class ShopListNotifier extends PaginatedNotifier<Product>
    implements ShopListActions {
  late ShopRepository _repository;

  @override
  int get pageSize => 20;

  @override
  PaginatedState<Product> build() {
    _repository = ref.read(shopRepositoryProvider);
    return super.build();
  }

  @override
  Future<List<Product>> loadPage(int page) {
    return _repository.fetchProducts(page: page, pageSize: pageSize);
  }
}

final shopListProvider =
    NotifierProvider<ShopListNotifier, PaginatedState<Product>>(
  ShopListNotifier.new,
);
