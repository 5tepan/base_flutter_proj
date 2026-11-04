import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_response.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/auth_handlers.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/chat_handlers.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/forms_handlers.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/shop_handlers.dart';
import 'package:dio/dio.dart';

/// Маршрутизация Fake API: METHOD + relative path → handler / fixture.
class FakeApiRouter {
  const FakeApiRouter({required this.apiRelativePath});

  final String apiRelativePath;

  Future<Response<String>> handle(RequestOptions request) async {
    final url = request.uri;
    final path = _relativePath(url);
    final method = request.method.toUpperCase();
    final body = _readBody(request.data);

    final handled =
        await FakeAuthHandlers.handle(
          method: method,
          path: path,
          url: url,
          body: body,
        ) ??
        await FakeShopHandlers.handle(method: method, path: path, url: url) ??
        await FakeChatHandlers.handle(
          method: method,
          path: path,
          url: url,
          body: body,
        ) ??
        await FakeFormsHandlers.handle(method: method, path: path, url: url);

    if (handled != null) {
      handled.requestOptions = request;
      return handled;
    }

    if (method == 'GET' && path == 'app/settings') {
      final response = FakeApiResponse.fromEnvelope(
        url,
        await FakeApiFixtureLoader.loadEnvelope('app/settings.get.json'),
      );
      response.requestOptions = request;
      return response;
    }

    final response = FakeApiResponse.notFound(
      url,
      message: 'Fake API route not found: $method $path',
    );
    response.requestOptions = request;
    return response;
  }

  String _relativePath(Uri url) {
    var path = url.path;
    var prefix = apiRelativePath;
    if (!prefix.startsWith('/')) {
      prefix = '/$prefix';
    }
    if (path.startsWith(prefix)) {
      path = path.substring(prefix.length);
    } else if (prefix.endsWith('/')) {
      final withoutSlash = prefix.substring(0, prefix.length - 1);
      if (path.startsWith(withoutSlash)) {
        path = path.substring(withoutSlash.length);
        if (path.startsWith('/')) {
          path = path.substring(1);
        }
      }
    }
    while (path.startsWith('/')) {
      path = path.substring(1);
    }
    return path;
  }

  String? _readBody(Object? data) {
    if (data is String) {
      return data;
    }
    if (data is FormData) {
      return jsonEncode(Map.fromEntries(data.fields));
    }
    if (data is Map) {
      return jsonEncode(data);
    }
    return null;
  }
}
