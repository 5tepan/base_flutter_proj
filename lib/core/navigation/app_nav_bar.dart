import 'package:base_flutter_proj/core/navigation/nav_item.dart';
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
    return Container(
      height: height,
      child: Row(
        mainAxisAlignment: alignment,
        children: List.generate(items.length, (index) {
          final item = items[index];

          return Padding(
            padding: itemPadding,
            child: GestureDetector(
              onTap: () => onTap(index),
              child: _NavBarItem(item: item, isSelected: index == currentIndex),
            ),
          );
        }),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;

  const _NavBarItem({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.blue : Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(item.icon, color: color),
            if (item.badge != null && item.badge! > 0)
              Positioned(right: -6, top: -6, child: _Badge(count: item.badge!)),
          ],
        ),
        const SizedBox(height: 4),
        Text(item.label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;

  const _Badge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        formatBadge(count),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }

  String formatBadge(int count) {
    if (count > 99) return '99+';
    return count.toString();
  }
}
