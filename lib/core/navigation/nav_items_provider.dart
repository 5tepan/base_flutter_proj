import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:base_flutter_proj/core/navigation/view/nav_item.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navItemsProvider = Provider<List<NavItem>>((ref) {
  // final cartCount = ref.watch(cartProvider).count;

  return [
    NavItem(label: S.current.navHome, icon: AssetsCatalog.icHome),
    NavItem(
      label: S.current.navShop,
      icon: AssetsCatalog.icShoppingCart,
      badge: 3,
    ),
    NavItem(label: S.current.navProfile, icon: AssetsCatalog.icUser),
  ];
});
