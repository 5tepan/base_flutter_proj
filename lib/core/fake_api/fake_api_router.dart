import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_response.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/auth_handlers.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/chat_handlers.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/forms_handlers.dart';
import 'package:base_flutter_proj/core/fake_api/handlers/shop_handlers.dart';
import 'package:http/http.dart' as http;

/// Маршрутизация Fake API: METHOD + relative path → handler / fixture.
class FakeApiRouter {
  const FakeApiRouter({required this.apiRelativePath});

  final String apiRelativePath;

  Future<http.Response> handle(http.BaseRequest request) async {
    final path = _relativePath(request.url);
    final method = request.method.toUpperCase();
    final body = await _readBody(request);

    final handled = await FakeAuthHandlers.handle(
          method: method,
          path: path,
          url: request.url,
          body: body,
        ) ??
        await FakeShopHandlers.handle(
          method: method,
          path: path,
          url: request.url,
        ) ??
        await FakeChatHandlers.handle(
          method: method,
          path: path,
          url: request.url,
          body: body,
        ) ??
        await FakeFormsHandlers.handle(
          method: method,
          path: path,
          url: request.url,
        );

    if (handled != null) {
      return handled;
    }

    if (method == 'GET' && path == 'app/settings') {
      return FakeApiResponse.fromEnvelope(
        request.url,
        await FakeApiFixtureLoader.loadEnvelope('app/settings.get.json'),
      );
    }

    return FakeApiResponse.notFound(
      request.url,
      message: 'Fake API route not found: $method $path',
    );
  }

  String _relativePath(Uri url) {
    var path = url.path;
    var prefix = apiRelativePath;
    if (!prefix.startsWith('/')) {
      prefix = '/$prefix';
    }
    if (prefix.endsWith('/') && prefix.length > 1) {
      // keep trailing slash for startsWith against `/api/...`
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

  Future<String?> _readBody(http.BaseRequest request) async {
    if (request is http.Request) {
      return request.body;
    }
    if (request is http.MultipartRequest) {
      return jsonEncode(request.fields);
    }
    return null;
  }
}
