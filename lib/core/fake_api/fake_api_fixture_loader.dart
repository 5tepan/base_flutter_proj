import 'dart:convert';

import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:flutter/services.dart';

/// Загрузка JSON-фикстур из [FakeApiConstants.assetsRoot].
abstract final class FakeApiFixtureLoader {
  static final Map<String, dynamic> _cache = {};

  static Future<Map<String, dynamic>> loadJson(String relativePath) async {
    final cached = _cache[relativePath];
    if (cached != null) {
      return Map<String, dynamic>.from(cached as Map);
    }

    final raw = await rootBundle.loadString(
      '${FakeApiConstants.assetsRoot}/$relativePath',
    );
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw FormatException('Fixture must be a JSON object: $relativePath');
    }
    _cache[relativePath] = decoded;
    return Map<String, dynamic>.from(decoded);
  }

  /// Тело ответа бэкенда `{ data, meta }` из файла-фикстуры.
  static Future<Map<String, dynamic>> loadEnvelope(String relativePath) {
    return loadJson(relativePath);
  }
}
