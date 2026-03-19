// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$authRoute];

RouteBase get $authRoute =>
    GoRouteData.$route(path: '/auth', factory: $AuthRoute._fromState);

mixin $AuthRoute on GoRouteData {
  static AuthRoute _fromState(GoRouterState state) => const AuthRoute();

  @override
  String get location => GoRouteData.$location('/auth');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
