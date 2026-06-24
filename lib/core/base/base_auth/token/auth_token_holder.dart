import 'package:base_flutter_proj/core/base/base_auth/model/auth_session.dart';

/// In-memory holder для токенов. Используется [BaseApiInterceptor].
class AuthTokenHolder {
  AuthSession? _session;

  String? get accessToken => _session?.accessToken;

  String? get refreshToken => _session?.refreshToken;

  AuthSession? get session => _session;

  void update(AuthSession? session) {
    _session = session;
  }

  void clear() {
    _session = null;
  }
}
