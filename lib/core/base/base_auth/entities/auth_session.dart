import 'package:base_flutter_proj/core/base/base_api/custom_json_formatters.dart';
import 'package:base_flutter_proj/core/base/base_auth/jwt/jwt_expiration.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_session.g.dart';

@JsonSerializable()
@DateTimeJsonConverter()
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.phoneNumber,
    this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String phoneNumber;

  /// Вычисляется на клиенте из `exp` в access token (JWT). Сохраняется в storage.
  final DateTime? expiresAt;

  bool get isExpired {
    final expiry = expiresAt ?? JwtExpiration.fromAccessToken(accessToken);
    if (expiry == null) {
      return false;
    }
    return DateTime.now().isAfter(expiry);
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionToJson(this);

  factory AuthSession.fromApiJson(Map<String, dynamic> json) {
    final session = AuthSession.fromJson(_normalizeApiJson(json));
    final expiresAt = JwtExpiration.fromAccessToken(session.accessToken);
    if (expiresAt == null) {
      return session;
    }

    return AuthSession(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
      phoneNumber: session.phoneNumber,
      expiresAt: expiresAt,
    );
  }

  static Map<String, dynamic> _normalizeApiJson(Map<String, dynamic> json) {
    return {
      'accessToken': json['access_token'] ?? json['accessToken'],
      'refreshToken': json['refresh_token'] ?? json['refreshToken'],
      'phoneNumber': json['phone_number'] ?? json['phoneNumber'],
    };
  }
}
