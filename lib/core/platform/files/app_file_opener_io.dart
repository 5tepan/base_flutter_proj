import 'package:open_file/open_file.dart';

Future<OpenResult> openAppFile(
  String? path, {
  required String unavailableMessage,
}) {
  if (path == null || path.isEmpty) {
    return Future.value(
      OpenResult(type: ResultType.error, message: unavailableMessage),
    );
  }
  return OpenFile.open(path);
}
