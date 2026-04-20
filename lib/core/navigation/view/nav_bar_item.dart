import 'package:base_flutter_proj/core/navigation/view/nav_badge.dart';
import 'package:base_flutter_proj/core/navigation/view/nav_item.dart';
import 'package:flutter/material.dart';

class NavBarItem extends StatelessWidget {
  final NavItem item;
  final bool isSelected;

  const NavBarItem({super.key, required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.blue : Colors.grey;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Image.asset(item.icon, color: color),
            if (item.badge != null && item.badge! > 0)
              Positioned(
                right: -6,
                top: -6,
                child: NavBadge(count: item.badge!),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(item.label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }
}
