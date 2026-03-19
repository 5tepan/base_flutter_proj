import 'package:base_flutter_proj/auth/auth_route.dart';
import 'package:base_flutter_proj/profile/profile_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: const ProfileRoute().location,
    navigatorKey: _rootNavigatorKey,
    routes: [$authRoute, navigationShell],
    redirect: (context, state) {
      final isAuth = true; //authState.isAuthenticated;

      final isAuthRoute = state.matchedLocation == const AuthRoute().location;

      if (!isAuth && !isAuthRoute) {
        return const AuthRoute().location;
      }

      return null;
    },
  );
});

final _rootNavigatorKey = GlobalKey<NavigatorState>();
