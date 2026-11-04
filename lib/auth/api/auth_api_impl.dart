import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/base/base_api/entities/base_api_response.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';

class AuthApiImpl implements AuthApi {
  AuthApiImpl(this._api);

  final PublicApi _api;

  static const _sendCodePath = 'auth/send-code';
  static const _verifyCodePath = 'auth/verify-code';
  static const _resendCodePath = 'auth/resend-code';
  static const _refreshTokenPath = 'auth/refresh';

  @override
  Future<void> requestConfirmationCode(String phoneNumber) async {
    final response = await _api.sendPostJsonRequest(
      _sendCodePath,
      body: {'phone': phoneNumber},
    );
    _ensureSuccess(response, fallback: AppErrorCode.sendCodeFailed);
  }

  @override
  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  }) async {
    final response = await _api.sendPostJsonRequest(
      _verifyCodePath,
      body: {
        'phone': phoneNumber,
        'code': confirmationCode,
      },
    );

    return _parseSession(
      response,
      fallback: AppErrorCode.verifyCodeFailed,
    );
  }

  @override
  Future<void> resendCode(String phoneNumber) async {
    final response = await _api.sendPostJsonRequest(
      _resendCodePath,
      body: {'phone': phoneNumber},
    );
    _ensureSuccess(response, fallback: AppErrorCode.resendCodeFailed);
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    final response = await _api.sendPostJsonRequest(
      _refreshTokenPath,
      body: {'refresh_token': refreshToken},
    );

    return _parseSession(
      response,
      fallback: AppErrorCode.refreshSessionFailed,
    );
  }

  AuthSession _parseSession(
    BaseApiResponse response, {
    required AppErrorCode fallback,
  }) {
    final parsed = ApiResponseParser.parseObjectFromResponse<AuthSession>(
      response,
      key: 'session',
      fromJson: AuthSession.fromApiJson,
      emptyErrorCode: fallback,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        _publicCode(parsed.errorCode, fallback),
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }

  void _ensureSuccess(
    BaseApiResponse response, {
    required AppErrorCode fallback,
  }) {
    if (response.isError) {
      throw AppException(
        _publicCode(response.errorCode, fallback),
        serverMessage: response.serverMessage,
      );
    }
  }

  /// Сетевые коды не подменяются доменной ошибкой, чтобы refresh не разлогинивал
  /// пользователя из-за обрыва связи.
  AppErrorCode _publicCode(AppErrorCode? code, AppErrorCode fallback) {
    if (code == AppErrorCode.noInternet ||
        code == AppErrorCode.connectionError ||
        code == AppErrorCode.unknownError) {
      return code!;
    }
    return fallback;
  }
}
