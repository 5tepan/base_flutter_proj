import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mime/mime.dart';

bool get appFilePickerNeedsBytes => true;

XFile? appXFileFromPlatformFile(PlatformFile file) {
  final bytes = file.bytes;
  if (bytes == null) {
    return null;
  }
  return XFile.fromData(
    bytes,
    name: file.name,
    mimeType: lookupMimeType(file.name),
  );
}
