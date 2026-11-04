import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_response.dart';
import 'package:dio/dio.dart';

abstract final class FakeFormsHandlers {
  static Future<Response<String>?> handle({
    required String method,
    required String path,
    required Uri url,
  }) async {
    if (method != 'GET') {
      return null;
    }

    final match = RegExp(r'^forms/([^/]+)/schema$').firstMatch(path);
    if (match == null) {
      return null;
    }

    final formId = match.group(1)!;
    if (formId != FakeApiConstants.demoFormId) {
      return FakeApiResponse.notFound(url, message: 'Form not found');
    }

    return FakeApiResponse.fromEnvelope(
      url,
      await FakeApiFixtureLoader.loadEnvelope('forms/demo.schema.get.json'),
    );
  }
}
