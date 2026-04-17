import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/router/route_access_policy.dart';
import 'package:base_flutter_proj/core/router/router_shell.dart';
import 'package:base_flutter_proj/home/home_route.dart';
import 'package:base_flutter_proj/web_view/route/web_view_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final routerRefresh = ValueNotifier<int>(0);
  ref.onDispose(routerRefresh.dispose);

  ref.listen<bool>(authStatusProvider, (_, __) {
    routerRefresh.value++;
  });

  final isAuthorized = ref.watch(authStatusProvider);
  final publicRouteMatchers = ref.watch(publicRouteMatchersProvider);
  final guestOnlyRouteMatchers = ref.watch(guestOnlyRouteMatchersProvider);
  final authRequiredRouteMatchers = ref.watch(
    authRequiredRouteMatchersProvider,
  );

  final otherRoutes = [$authRoute, $webViewRoute];

  return GoRouter(
    initialLocation: const HomeRoute().location,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: routerRefresh,
    routes: [...otherRoutes, navigationShell],
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublicRoute = publicRouteMatchers.any(
        (matcher) => matcher.matches(location),
      );
      final isGuestOnlyRoute = guestOnlyRouteMatchers.any(
        (matcher) => matcher.matches(location),
      );
      final isAuthRequiredRoute = authRequiredRouteMatchers.any(
        (matcher) => matcher.matches(location),
      );

      if (!isAuthorized && isAuthRequiredRoute && !isPublicRoute) {
        return const AuthByPhoneFormRoute().location;
      }

      if (isAuthorized && isGuestOnlyRoute) {
        return const HomeRoute().location;
      }

      return null;
    },
  );
});

final _rootNavigatorKey = GlobalKey<NavigatorState>();
