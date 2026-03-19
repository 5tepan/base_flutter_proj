import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'shop_route.g.dart';

@TypedGoRoute<ShopRoute>(path: '/shop')
class ShopRoute extends GoRouteData with $ShopRoute {
  const ShopRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Placeholder();
  }
}
