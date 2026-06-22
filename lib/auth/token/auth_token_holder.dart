import 'package:base_flutter_proj/auth/model/auth_session.dart';

/// In-memory holder for auth tokens used by [BaseApiInterceptor].
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
