import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/shop/api/shop_api.dart';
import 'package:base_flutter_proj/shop/entities/product.dart';

/// Mock API для dev без бэкенда.
/// Для демо [AppErrorPage] откройте товар с id [errorProductId].
class MockShopApi implements ShopApi {
  static const int totalMockItems = 45;
  static const String errorProductId = 'product_error';

  static const Duration _latency = Duration(milliseconds: 400);

  @override
  Future<List<Product>> fetchProducts({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(_latency);

    final start = page * pageSize;
    if (start >= totalMockItems) {
      return [];
    }

    final count = (start + pageSize > totalMockItems)
        ? totalMockItems - start
        : pageSize;

    return List.generate(
      count,
      (index) => productAt(start + index),
    );
  }

  @override
  Future<Product> fetchProduct(String id) async {
    await Future<void>.delayed(_latency);

    if (id == errorProductId) {
      throw const AppException(AppErrorCode.dataNotFound);
    }

    final index = int.tryParse(id.replaceFirst('product_', ''));
    if (index == null || index < 0 || index >= totalMockItems) {
      throw const AppException(AppErrorCode.dataNotFound);
    }

    return productAt(index);
  }

  static Product productAt(int index) {
    return Product(
      id: 'product_$index',
      name: 'Product ${index + 1}',
      description: 'Description for product ${index + 1}',
    );
  }
}
