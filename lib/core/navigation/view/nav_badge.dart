import 'package:flutter/material.dart';

class NavBadge extends StatelessWidget {
  final int count;

  const NavBadge({super.key, required this.count});

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
