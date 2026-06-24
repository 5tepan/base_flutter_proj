import 'package:base_flutter_proj/shop/product_detail_page.dart';
import 'package:base_flutter_proj/shop/shop_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'shop_route.g.dart';

@TypedGoRoute<ShopRoute>(
  path: '/shop',
  routes: [
    TypedGoRoute<ShopProductRoute>(path: 'product/:productId'),
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
