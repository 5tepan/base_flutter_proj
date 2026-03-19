import 'package:base_flutter_proj/core/navigation/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navItemsProvider = Provider<List<NavItem>>((ref) {
  // final cartCount = ref.watch(cartProvider).count;

  return [
    NavItem(label: 'Home', icon: Icons.home),
    NavItem(label: 'Shop', icon: Icons.shop, badge: 3),
    NavItem(label: 'Profile', icon: Icons.person),
  ];
});
