import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBarItemConfig {
  const NavBarItemConfig({
    required this.icon,
    this.badge,
  });

  final String icon;

  /// Счётчик на иконке таба. Подключите реальный provider, например:
  /// `badge: ref.watch(cartProvider).count`.
  final int? badge;
}

final navBarItemsProvider = Provider<List<NavBarItemConfig>>((ref) {
  // final cartCount = ref.watch(cartProvider).count;

  return const [
    NavBarItemConfig(icon: AssetsCatalog.icHome),
    NavBarItemConfig(
      icon: AssetsCatalog.icShoppingCart,
      badge: 3, // заготовка: заменить на cartCount
    ),
    NavBarItemConfig(icon: AssetsCatalog.icUser),
  ];
});
