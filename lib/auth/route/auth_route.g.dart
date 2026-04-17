// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$authRoute];

RouteBase get $authRoute => GoRouteData.$route(
  path: '/auth',
  factory: $AuthRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'phone',
      factory: $AuthByPhoneFormRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'confirm/:phoneNumber',
      factory: $PhoneConfirmationFormRoute._fromState,
    ),
  ],
);

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

mixin $AuthByPhoneFormRoute on GoRouteData {
  static AuthByPhoneFormRoute _fromState(GoRouterState state) =>
      const AuthByPhoneFormRoute();

  @override
  String get location => GoRouteData.$location('/auth/phone');

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

mixin $PhoneConfirmationFormRoute on GoRouteData {
  static PhoneConfirmationFormRoute _fromState(GoRouterState state) =>
      PhoneConfirmationFormRoute(
        phoneNumber: state.pathParameters['phoneNumber']!,
      );

  PhoneConfirmationFormRoute get _self => this as PhoneConfirmationFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/auth/confirm/${Uri.encodeComponent(_self.phoneNumber)}',
  );

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
