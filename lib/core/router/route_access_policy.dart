import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/home/home_route.dart';
import 'package:base_flutter_proj/profile/route/profile_route.dart';
import 'package:base_flutter_proj/shop/shop_route.dart';
import 'package:base_flutter_proj/web_view/route/web_view_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Публичные роуты (для всех)
final publicRouteMatchersProvider = Provider<List<RouteMatcher>>((ref) {
  return <RouteMatcher>[RouteMatcher.exact(const WebViewRoute().location)];
});

/// Роуты для гостей (для неавторизованных пользователей)
final guestOnlyRouteMatchersProvider = Provider<List<RouteMatcher>>((ref) {
  return <RouteMatcher>[RouteMatcher.prefix(const AuthRoute().location)];
});

/// Роуты для авторизованных пользователей (для авторизованных пользователей)
final authRequiredRouteMatchersProvider = Provider<List<RouteMatcher>>((ref) {
  return <RouteMatcher>[
    RouteMatcher.prefix(const HomeRoute().location),
    RouteMatcher.prefix(const ShopRoute().location),
    RouteMatcher.prefix(const ProfileRoute().location),
  ];
});

class RouteMatcher {
  const RouteMatcher._(this._match);

  factory RouteMatcher.exact(String path) {
    return RouteMatcher._((location) => location == path);
  }

  factory RouteMatcher.prefix(String prefix) {
    return RouteMatcher._(
      (location) => location == prefix || location.startsWith('$prefix/'),
    );
  }

  final bool Function(String location) _match;

  bool matches(String location) => _match(location);
}
