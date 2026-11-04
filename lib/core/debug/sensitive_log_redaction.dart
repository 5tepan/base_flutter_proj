/// Убирает секреты из отладочных HTTP-логов.
abstract final class SensitiveLogRedaction {
  static const redacted = '<redacted>';

  static const _headerNames = {'authorization', 'cookie', 'set-cookie'};

  static const _queryNames = {'token', 'access_token', 'refresh_token'};

  static Map<String, String> headers(Map<String, String> headers) {
    final copy = Map<String, String>.from(headers);
    for (final key in copy.keys.toList()) {
      if (_headerNames.contains(key.toLowerCase())) {
        copy[key] = redacted;
      }
    }
    return copy;
  }

  static String url(Uri uri) {
    final params = Map<String, String>.from(uri.queryParameters);
    var changed = false;
    for (final key in _queryNames) {
      if (params.containsKey(key)) {
        params[key] = redacted;
        changed = true;
      }
    }
    if (!changed) {
      return uri.toString();
    }
    return uri.replace(queryParameters: params).toString();
  }
}
