import 'package:base_flutter_proj/core/base/base_pages/authenticated_placeholder_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'home_route.g.dart';

const String _homePath = '/home';

@TypedGoRoute<HomeRoute>(path: _homePath)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthenticatedPlaceholderPage();
  }
}
