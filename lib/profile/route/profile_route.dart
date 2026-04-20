import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'profile_route.g.dart';

const String _profilePath = '/profile';

@TypedGoRoute<ProfileRoute>(path: _profilePath)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Placeholder();
  }
}
