import 'package:base_flutter_proj/auth/model/auth_session.dart';

abstract class AuthApi {
  Future<void> requestConfirmationCode(String phoneNumber);

  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  });

  Future<void> resendCode(String phoneNumber);

  Future<AuthSession> refreshToken(String refreshToken);
}
