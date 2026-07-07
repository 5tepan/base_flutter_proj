import 'package:base_flutter_proj/core/navigation/view/nav_bar_item.dart';
import 'package:base_flutter_proj/core/navigation/view/nav_item.dart';
import 'package:flutter/material.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    required this.height,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final double height;
  final List<NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final isSelected = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onTap(index),
              child: Center(
                child: NavBarItem(item: item, isSelected: isSelected),
              ),
            ),
          );
        }),
      ),
    );
  }
}
