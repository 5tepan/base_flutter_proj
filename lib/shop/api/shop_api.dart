import 'package:base_flutter_proj/shop/model/product.dart';

abstract class ShopApi {
  Future<List<Product>> fetchProducts({
    required int page,
    required int pageSize,
  });

  Future<Product> fetchProduct(String id);
}
