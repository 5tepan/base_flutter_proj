import 'package:base_flutter_proj/web_view/web_view_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'web_view_route.g.dart';

const String _webViewPath = '/web-view';

@TypedGoRoute<WebViewRoute>(path: _webViewPath)
class WebViewRoute extends GoRouteData with $WebViewRoute {
  const WebViewRoute({this.url, this.title = 'Документ'});

  final String? url;
  final String title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WebViewPage(url: url, title: title);
  }
}
