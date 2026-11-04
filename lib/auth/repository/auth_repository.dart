import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/model/token_refresh_result.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_auth/storage/auth_session_storage.dart';
import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';

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

  Future<TokenRefreshResult>? _refreshInFlight;

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

  /// Один refresh на все параллельные 401.
  ///
  /// Повторный вызов, пока первый ещё идёт, ждёт тот же результат и не шлёт
  /// второй запрос: иначе ротация refresh-токена на сервере разлогинит сессию.
  Future<TokenRefreshResult> refreshTokens() {
    final inFlight = _refreshInFlight;
    if (inFlight != null) {
      return inFlight;
    }

    final future = _refreshTokensOnce();
    _refreshInFlight = future;
    return future.whenComplete(() {
      if (identical(_refreshInFlight, future)) {
        _refreshInFlight = null;
      }
    });
  }

  Future<TokenRefreshResult> _refreshTokensOnce() async {
    final refreshToken =
        _tokenHolder.refreshToken ?? (await _storage.read())?.refreshToken;
    if (refreshToken == null || refreshToken.isEmpty) {
      await signOut();
      return const TokenRefreshRejected();
    }

    try {
      final session = await _api.refreshToken(refreshToken);
      await saveSession(session);
      return TokenRefreshSuccess(session);
    } on AppException catch (error) {
      if (_isTransient(error.code)) {
        return const TokenRefreshUnavailable();
      }
      await signOut();
      return const TokenRefreshRejected();
    } catch (_) {
      return const TokenRefreshUnavailable();
    }
  }

  bool _isTransient(AppErrorCode code) {
    return code == AppErrorCode.noInternet ||
        code == AppErrorCode.connectionError ||
        code == AppErrorCode.unknownError;
  }
}
