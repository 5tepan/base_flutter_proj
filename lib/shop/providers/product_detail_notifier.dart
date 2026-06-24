import 'package:base_flutter_proj/core/base/model/notifiers/item_notifier.dart';
import 'package:base_flutter_proj/core/base/model/states/entity_state.dart';
import 'package:base_flutter_proj/shop/model/product.dart';
import 'package:base_flutter_proj/shop/providers/shop_providers.dart';
import 'package:base_flutter_proj/shop/repository/shop_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailNotifier extends ItemNotifier<Product> {
  ProductDetailNotifier(this.productId);

  final String productId;

  late ShopRepository _repository;

  @override
  EntityState<Product> build() {
    _repository = ref.read(shopRepositoryProvider);
    return super.build();
  }

  @override
  Future<Product> loadItem() {
    return _repository.fetchProduct(productId);
  }
}

final productDetailProvider = NotifierProvider.family<
    ProductDetailNotifier,
    EntityState<Product>,
    String>(
  ProductDetailNotifier.new,
);
