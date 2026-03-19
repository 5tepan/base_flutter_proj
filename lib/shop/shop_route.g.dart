// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$shopRoute];

RouteBase get $shopRoute =>
    GoRouteData.$route(path: '/shop', factory: $ShopRoute._fromState);

mixin $ShopRoute on GoRouteData {
  static ShopRoute _fromState(GoRouterState state) => const ShopRoute();

  @override
  String get location => GoRouteData.$location('/shop');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
