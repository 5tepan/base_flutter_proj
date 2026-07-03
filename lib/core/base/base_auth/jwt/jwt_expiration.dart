import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

/// Чтение `exp` из access token (без проверки подписи — только для UX).
///
/// Валидация токена всегда на сервере; клиент использует `exp` для [AuthSession.isExpired].
abstract final class JwtExpiration {
  static DateTime? fromAccessToken(String? token) {
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final payload = JWT.decode(token).payload;
      if (payload is! Map<String, dynamic>) {
        return null;
      }

      final exp = payload['exp'];
      if (exp is int) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true).toLocal();
      }
      if (exp is double) {
        return DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000, isUtc: true)
            .toLocal();
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
