import 'package:base_flutter_proj/core/errors/app_error_code.dart';

class AuthException implements Exception {
  const AuthException(this.code, {this.serverMessage});

  final AppErrorCode code;
  final String? serverMessage;

  @override
  String toString() => 'AuthException($code, serverMessage: $serverMessage)';
}
