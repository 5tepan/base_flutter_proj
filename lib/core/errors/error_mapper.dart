import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';

typedef MappedError = ({AppErrorCode code, String? serverMessage});

abstract final class ErrorMapper {
  static MappedError from(Object error) {
    if (error is AppException) {
      return (code: error.code, serverMessage: error.serverMessage);
    }
    return (code: AppErrorCode.unknownError, serverMessage: null);
  }
}
