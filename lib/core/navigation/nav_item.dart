import 'package:flutter/material.dart';

class NavItem {
  final String label;
  final IconData icon;
  final int? badge;

  const NavItem({required this.label, required this.icon, this.badge});
}
