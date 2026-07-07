// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$profileRoute];

RouteBase get $profileRoute => GoRouteData.$route(
  path: '/profile',
  factory: $ProfileRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'media-demo',
      factory: $MediaFilesDemoRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'calendar-demo',
      factory: $CalendarDemoRoute._fromState,
    ),
  ],
);

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

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

mixin $MediaFilesDemoRoute on GoRouteData {
  static MediaFilesDemoRoute _fromState(GoRouterState state) =>
      const MediaFilesDemoRoute();

  @override
  String get location => GoRouteData.$location('/profile/media-demo');

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

mixin $CalendarDemoRoute on GoRouteData {
  static CalendarDemoRoute _fromState(GoRouterState state) =>
      const CalendarDemoRoute();

  @override
  String get location => GoRouteData.$location('/profile/calendar-demo');

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
