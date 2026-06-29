import 'package:base_flutter_proj/core/base/base_api/custom_json_formatters.dart';
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
  final DateTime? expiresAt;

  bool get isExpired {
    final expiresAt = this.expiresAt;
    if (expiresAt == null) {
      return false;
    }
    return DateTime.now().isAfter(expiresAt);
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionToJson(this);

  factory AuthSession.fromApiJson(Map<String, dynamic> json) =>
      AuthSession.fromJson(_normalizeApiJson(json));

  static Map<String, dynamic> _normalizeApiJson(Map<String, dynamic> json) {
    final expiresRaw = json['expires_at'] ?? json['expiresAt'];
    String? expiresAt;
    if (expiresRaw is String) {
      expiresAt = expiresRaw;
    } else if (expiresRaw is int) {
      expiresAt = DateTime.fromMillisecondsSinceEpoch(expiresRaw)
          .toUtc()
          .toIso8601String();
    }

    return {
      'accessToken': json['access_token'] ?? json['accessToken'],
      'refreshToken': json['refresh_token'] ?? json['refreshToken'],
      'phoneNumber': json['phone_number'] ?? json['phoneNumber'],
      if (expiresAt != null) 'expiresAt': expiresAt,
    };
  }
}
