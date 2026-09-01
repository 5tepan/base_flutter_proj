import 'package:base_flutter_proj/core/assets/app_asset.dart';

class NavItem {
  final String label;
  final AppAsset icon;
  final int? badge;

  const NavItem({required this.label, required this.icon, this.badge});
}
