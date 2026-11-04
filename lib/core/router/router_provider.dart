import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/router/route_access_policy.dart';
import 'package:base_flutter_proj/core/router/router_shell.dart';
import 'package:base_flutter_proj/core/router/session_gate_page.dart';
import 'package:base_flutter_proj/home/route/home_route.dart';
import 'package:base_flutter_proj/web_view/route/web_view_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final routerRefresh = ValueNotifier<int>(0);
  ref.onDispose(routerRefresh.dispose);

  ref.listen<AsyncValue<AuthSession?>>(
    authSessionProvider,
    (_, __) => routerRefresh.value++,
  );

  final publicRouteMatchers = ref.watch(publicRouteMatchersProvider);
  final guestOnlyRouteMatchers = ref.watch(guestOnlyRouteMatchersProvider);
  final authRequiredRouteMatchers = ref.watch(
    authRequiredRouteMatchersProvider,
  );

  final otherRoutes = [$authRoute, $webViewRoute];

  return GoRouter(
    initialLocation: const HomeRoute().location,
    navigatorKey: rootNavigatorKey,
    refreshListenable: routerRefresh,
    routes: [
      GoRoute(
        path: SessionGatePage.location,
        builder: (context, state) => const SessionGatePage(),
      ),
      ...otherRoutes,
      navigationShell,
    ],
    redirect: (context, state) {
      final sessionAsync = ref.read(authSessionProvider);
      final location = state.matchedLocation;
      final isSessionGate = location == SessionGatePage.location;
      if (sessionAsync.isLoading) {
        return isSessionGate ? null : SessionGatePage.location;
      }
      if (isSessionGate) {
        final isAuthorized = sessionAsync.value != null;
        return isAuthorized
            ? const HomeRoute().location
            : const AuthByPhoneFormRoute().location;
      }

      final isAuthorized = sessionAsync.value != null;
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

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
