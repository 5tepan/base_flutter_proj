import 'package:base_flutter_proj/core/errors/app_error_code.dart';

/// Доменное исключение с [AppErrorCode]. Бросается из API/repository.
class AppException implements Exception {
  const AppException(this.code, {this.serverMessage});

  final AppErrorCode code;
  final String? serverMessage;

  @override
  String toString() => 'AppException($code, serverMessage: $serverMessage)';
}
