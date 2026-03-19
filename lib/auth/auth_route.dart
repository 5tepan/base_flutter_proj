import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'auth_route.g.dart';

@TypedGoRoute<AuthRoute>(path: '/auth')
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Placeholder();
  }
}
