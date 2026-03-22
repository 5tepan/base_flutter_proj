import 'package:base_flutter_proj/home/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'router_shell.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: const HomeRoute().location,
    navigatorKey: _rootNavigatorKey,
    routes: [navigationShell],
  );
});

final _rootNavigatorKey = GlobalKey<NavigatorState>();
