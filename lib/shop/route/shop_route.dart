import 'package:base_flutter_proj/shop/product_detail_page.dart';
import 'package:base_flutter_proj/shop/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'shop_route.g.dart';

const String _shopPath = '/shop';
const String _productPath = 'product/:productId';

@TypedGoRoute<ShopRoute>(
  path: _shopPath,
  routes: [
    TypedGoRoute<ShopProductRoute>(path: _productPath),
  ],
)
class ShopRoute extends GoRouteData with $ShopRoute {
  const ShopRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ShopPage();
  }
}

class ShopProductRoute extends GoRouteData with $ShopProductRoute {
  const ShopProductRoute({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductDetailPage(productId: productId);
  }
}
