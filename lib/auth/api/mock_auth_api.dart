import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/model/auth_exception.dart';
import 'package:base_flutter_proj/auth/model/auth_session.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';

/// Mock API for local development without backend.
/// Verification code: [mockVerificationCode].
class MockAuthApi implements AuthApi {
  static const String mockVerificationCode = '1234';

  @override
  Future<void> requestConfirmationCode(String phoneNumber) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (phoneNumber.trim().isEmpty) {
      throw const AuthException(AppErrorCode.phoneRequired);
    }
  }

  @override
  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (confirmationCode != mockVerificationCode) {
      throw const AuthException(AppErrorCode.invalidConfirmationCode);
    }

    return AuthSession(
      accessToken: 'mock_access_$phoneNumber',
      refreshToken: 'mock_refresh_$phoneNumber',
      phoneNumber: phoneNumber,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }

  @override
  Future<void> resendCode(String phoneNumber) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (!refreshToken.startsWith('mock_refresh_')) {
      throw const AuthException(AppErrorCode.sessionExpired);
    }

    final phoneNumber = refreshToken.replaceFirst('mock_refresh_', '');
    return AuthSession(
      accessToken: 'mock_access_refreshed_$phoneNumber',
      refreshToken: 'mock_refresh_$phoneNumber',
      phoneNumber: phoneNumber,
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
    );
  }
}
