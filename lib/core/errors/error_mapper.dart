import 'package:base_flutter_proj/auth/model/auth_exception.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';

typedef MappedError = ({AppErrorCode code, String? serverMessage});

abstract final class ErrorMapper {
  static MappedError from(Object error) {
    if (error is AuthException) {
      return (code: error.code, serverMessage: error.serverMessage);
    }
    return (code: AppErrorCode.unknownError, serverMessage: null);
  }
}
