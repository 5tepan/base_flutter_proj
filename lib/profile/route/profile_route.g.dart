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
    GoRouteData.$route(
      path: 'dynamic-form-demo',
      factory: $DynamicFormDemoRoute._fromState,
    ),
    GoRouteData.$route(path: 'chat', factory: $ChatDirectRoute._fromState),
    GoRouteData.$route(
      path: 'chats',
      factory: $ChatListRoute._fromState,
      routes: [
        GoRouteData.$route(path: ':roomId', factory: $ChatRoomRoute._fromState),
      ],
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

mixin $DynamicFormDemoRoute on GoRouteData {
  static DynamicFormDemoRoute _fromState(GoRouterState state) =>
      const DynamicFormDemoRoute();

  @override
  String get location => GoRouteData.$location('/profile/dynamic-form-demo');

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

mixin $ChatDirectRoute on GoRouteData {
  static ChatDirectRoute _fromState(GoRouterState state) =>
      const ChatDirectRoute();

  @override
  String get location => GoRouteData.$location('/profile/chat');

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

mixin $ChatListRoute on GoRouteData {
  static ChatListRoute _fromState(GoRouterState state) => const ChatListRoute();

  @override
  String get location => GoRouteData.$location('/profile/chats');

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

mixin $ChatRoomRoute on GoRouteData {
  static ChatRoomRoute _fromState(GoRouterState state) => ChatRoomRoute(
    roomId: state.pathParameters['roomId']!,
    title: state.uri.queryParameters['title'],
  );

  ChatRoomRoute get _self => this as ChatRoomRoute;

  @override
  String get location => GoRouteData.$location(
    '/profile/chats/${Uri.encodeComponent(_self.roomId)}',
    queryParams: {if (_self.title != null) 'title': _self.title},
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
