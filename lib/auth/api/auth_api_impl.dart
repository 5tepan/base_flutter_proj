import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/base/base_auth/model/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/base/base_api/base_api_response.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';

class AuthApiImpl extends PublicApi implements AuthApi {
  AuthApiImpl({
    required super.config,
    required super.packageInfo,
    required super.checkConnection,
  });

  static const _sendCodePath = 'auth/send-code';
  static const _verifyCodePath = 'auth/verify-code';
  static const _resendCodePath = 'auth/resend-code';
  static const _refreshTokenPath = 'auth/refresh';

  @override
  Future<void> requestConfirmationCode(String phoneNumber) async {
    final response = await sendPostJsonRequest(
      _sendCodePath,
      body: {'phone': phoneNumber},
    );
    _ensureSuccess(response, defaultCode: AppErrorCode.sendCodeFailed);
  }

  @override
  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  }) async {
    final response = await sendPostJsonRequest(
      _verifyCodePath,
      body: {
        'phone': phoneNumber,
        'code': confirmationCode,
      },
    );

    return _parseSession(
      response,
      defaultCode: AppErrorCode.verifyCodeFailed,
    );
  }

  @override
  Future<void> resendCode(String phoneNumber) async {
    final response = await sendPostJsonRequest(
      _resendCodePath,
      body: {'phone': phoneNumber},
    );
    _ensureSuccess(response, defaultCode: AppErrorCode.resendCodeFailed);
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    final response = await sendPostJsonRequest(
      _refreshTokenPath,
      body: {'refresh_token': refreshToken},
    );

    return _parseSession(
      response,
      defaultCode: AppErrorCode.refreshSessionFailed,
    );
  }

  AuthSession _parseSession(
    BaseApiResponse response, {
    required AppErrorCode defaultCode,
  }) {
    final parsed = ApiResponseParser.parseObjectFromResponse<AuthSession>(
      response,
      key: 'session',
      fromJson: AuthSession.fromApiJson,
      emptyErrorCode: defaultCode,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? defaultCode,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }

  void _ensureSuccess(
    BaseApiResponse response, {
    required AppErrorCode defaultCode,
  }) {
    if (response.isError) {
      throw AppException(
        response.errorCode ?? defaultCode,
        serverMessage: response.serverMessage,
      );
    }
  }
}
