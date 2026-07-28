import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_response.dart';
import 'package:http/http.dart' as http;

abstract final class FakeShopHandlers {
  static Future<http.Response?> handle({
    required String method,
    required String path,
    required Uri url,
  }) async {
    if (method != 'GET') {
      return null;
    }

    if (path == 'shop/products') {
      return _list(url);
    }

    final match = RegExp(r'^shop/products/(.+)$').firstMatch(path);
    if (match != null) {
      return _detail(url, match.group(1)!);
    }

    return null;
  }

  static Future<http.Response> _list(Uri url) async {
    final catalog = await FakeApiFixtureLoader.loadJson('shop/products.json');
    final products = List<Map<String, dynamic>>.from(
      (catalog['products'] as List).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );

    final page = int.tryParse(url.queryParameters['page'] ?? '0') ?? 0;
    final pageSize =
        int.tryParse(url.queryParameters['pageSize'] ?? '20') ?? 20;
    final start = page * pageSize;
    if (start >= products.length) {
      return FakeApiResponse.json(url, data: {'products': <dynamic>[]});
    }

    final end = (start + pageSize > products.length)
        ? products.length
        : start + pageSize;
    return FakeApiResponse.json(
      url,
      data: {'products': products.sublist(start, end)},
    );
  }

  static Future<http.Response> _detail(Uri url, String id) async {
    if (id == FakeApiConstants.shopErrorProductId) {
      return FakeApiResponse.notFound(url, message: 'Product not found');
    }

    final catalog = await FakeApiFixtureLoader.loadJson('shop/products.json');
    final products = catalog['products'] as List;
    for (final item in products) {
      final product = Map<String, dynamic>.from(item as Map);
      if (product['id'] == id) {
        return FakeApiResponse.json(url, data: {'product': product});
      }
    }

    return FakeApiResponse.notFound(url, message: 'Product not found');
  }
}
