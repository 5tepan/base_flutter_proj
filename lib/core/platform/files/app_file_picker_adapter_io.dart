import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

bool get appFilePickerNeedsBytes => false;

XFile? appXFileFromPlatformFile(PlatformFile file) {
  final path = file.path;
  return path == null ? null : XFile(path, name: file.name);
}
