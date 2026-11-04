import 'package:base_flutter_proj/core/platform/files/app_file_opener_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/files/app_file_opener_io.dart'
    as implementation;
import 'package:open_file/open_file.dart';

export 'package:open_file/open_file.dart' show OpenResult, ResultType;

Future<OpenResult> openAppFile(
  String? path, {
  required String unavailableMessage,
}) => implementation.openAppFile(path, unavailableMessage: unavailableMessage);
