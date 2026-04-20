import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:base_flutter_proj/core/navigation/view/nav_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navItemsProvider = Provider<List<NavItem>>((ref) {
  // final cartCount = ref.watch(cartProvider).count;

  return [
    NavItem(label: 'Home', icon: AssetsCatalog.icHome),
    NavItem(label: 'Shop', icon: AssetsCatalog.icShoppingCart, badge: 3),
    NavItem(label: 'Profile', icon: AssetsCatalog.icUser),
  ];
});
