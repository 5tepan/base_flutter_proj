// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_view_route.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$webViewRoute];

RouteBase get $webViewRoute =>
    GoRouteData.$route(path: '/web-view', factory: $WebViewRoute._fromState);

mixin $WebViewRoute on GoRouteData {
  static WebViewRoute _fromState(GoRouterState state) => WebViewRoute(
    url: state.uri.queryParameters['url'],
    title: state.uri.queryParameters['title'] ?? 'Документ',
  );

  WebViewRoute get _self => this as WebViewRoute;

  @override
  String get location => GoRouteData.$location(
    '/web-view',
    queryParams: {
      if (_self.url != null) 'url': _self.url,
      'title': _self.title,
    },
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
