import 'package:base_flutter_proj/core/navigation/view/nav_bar_item.dart';
import 'package:base_flutter_proj/core/navigation/view/nav_item.dart';
import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  final double height;
  final List<NavItem> items;
  final int currentIndex;
  final Function(int) onTap;

  final EdgeInsets itemPadding;
  final MainAxisAlignment alignment;

  const AppNavBar({
    required this.height,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 8),
    this.alignment = MainAxisAlignment.spaceBetween,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: alignment,
        children: List.generate(items.length, (index) {
          final item = items[index];
          return Padding(
            padding: itemPadding,
            child: GestureDetector(
              onTap: () => onTap(index),
              child: NavBarItem(item: item, isSelected: index == currentIndex),
            ),
          );
        }),
      ),
    );
  }
}
