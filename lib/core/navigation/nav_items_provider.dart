import 'package:base_flutter_proj/core/assets/app_asset.dart';
import 'package:base_flutter_proj/core/assets/app_assets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavBarItemConfig {
  const NavBarItemConfig({
    required this.icon,
    this.badge,
  });

  final AppAsset icon;

  /// Счётчик на иконке таба. Подключите реальный provider, например:
  /// `badge: ref.watch(cartProvider).count`.
  final int? badge;
}

final navBarItemsProvider = Provider<List<NavBarItemConfig>>((ref) {
  // final cartCount = ref.watch(cartProvider).count;

  return const [
    NavBarItemConfig(icon: AppAssets.home),
    NavBarItemConfig(
      icon: AppAssets.shoppingCart,
      badge: 3, // заготовка: заменить на cartCount
    ),
    NavBarItemConfig(icon: AppAssets.user),
  ];
});
