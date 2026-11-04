import 'package:open_file/open_file.dart';

Future<OpenResult> openAppFile(
  String? path, {
  required String unavailableMessage,
}) async => OpenResult(type: ResultType.error, message: unavailableMessage);
