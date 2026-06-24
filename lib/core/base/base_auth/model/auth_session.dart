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

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'phoneNumber': phoneNumber,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      phoneNumber: json['phoneNumber'] as String,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.tryParse(json['expiresAt'] as String),
    );
  }

  factory AuthSession.fromApiJson(Map<String, dynamic> json) {
    return AuthSession(
      accessToken:
          json['access_token'] as String? ?? json['accessToken'] as String,
      refreshToken:
          json['refresh_token'] as String? ?? json['refreshToken'] as String,
      phoneNumber:
          json['phone_number'] as String? ?? json['phoneNumber'] as String,
      expiresAt: _parseExpiresAt(json),
    );
  }

  static DateTime? _parseExpiresAt(Map<String, dynamic> json) {
    final raw = json['expires_at'] ?? json['expiresAt'];
    if (raw is String) {
      return DateTime.tryParse(raw);
    }
    if (raw is int) {
      return DateTime.fromMillisecondsSinceEpoch(raw);
    }
    return null;
  }
}
