import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/base/base_auth/model/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_auth/storage/auth_session_storage.dart';
import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';

class AuthRepository {
  AuthRepository({
    required AuthApi api,
    required AuthSessionStorage storage,
    required AuthTokenHolder tokenHolder,
  }) : _api = api,
       _storage = storage,
       _tokenHolder = tokenHolder;

  final AuthApi _api;
  final AuthSessionStorage _storage;
  final AuthTokenHolder _tokenHolder;

  Future<AuthSession?> loadSession() async {
    final session = await _storage.read();
    _tokenHolder.update(session);
    return session;
  }

  Future<void> requestConfirmationCode(String phoneNumber) {
    return _api.requestConfirmationCode(phoneNumber);
  }

  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  }) {
    return _api.verifyCode(
      phoneNumber: phoneNumber,
      confirmationCode: confirmationCode,
    );
  }

  Future<void> resendCode(String phoneNumber) {
    return _api.resendCode(phoneNumber);
  }

  Future<AuthSession> saveSession(AuthSession session) async {
    await _storage.save(session);
    _tokenHolder.update(session);
    return session;
  }

  Future<void> signOut() async {
    await _storage.clear();
    _tokenHolder.clear();
  }

  Future<bool> refreshTokens() async {
    final refreshToken =
        _tokenHolder.refreshToken ?? (await _storage.read())?.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final session = await _api.refreshToken(refreshToken);
      await saveSession(session);
      return true;
    } on AppException {
      await signOut();
      return false;
    } catch (_) {
      await signOut();
      return false;
    }
  }
}
