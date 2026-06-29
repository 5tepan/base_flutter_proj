import 'package:base_flutter_proj/shop/api/shop_api.dart';
import 'package:base_flutter_proj/shop/entities/product.dart';

class ShopRepository {
  ShopRepository(this._api);

  final ShopApi _api;

  Future<List<Product>> fetchProducts({
    required int page,
    required int pageSize,
  }) {
    return _api.fetchProducts(page: page, pageSize: pageSize);
  }

  Future<Product> fetchProduct(String id) {
    return _api.fetchProduct(id);
  }
}
