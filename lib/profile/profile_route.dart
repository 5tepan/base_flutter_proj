import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'profile_route.g.dart';

@TypedGoRoute<ProfileRoute>(path: '/profile')
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Placeholder();
  }
}
