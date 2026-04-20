import 'package:base_flutter_proj/core/navigation/bottom_navigation_page.dart';
import 'package:base_flutter_proj/home/home_route.dart';
import 'package:base_flutter_proj/profile/route/profile_route.dart';
import 'package:base_flutter_proj/shop/shop_route.dart';
import 'package:go_router/go_router.dart';

final navigationShell = StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return BottomNavigationPage(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(routes: [$homeRoute]),
    StatefulShellBranch(routes: [$shopRoute]),
    StatefulShellBranch(routes: [$profileRoute]),
  ],
);
