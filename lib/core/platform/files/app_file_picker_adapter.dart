import 'package:base_flutter_proj/core/platform/files/app_file_picker_adapter_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/files/app_file_picker_adapter_io.dart'
    as implementation;
import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

bool get appFilePickerNeedsBytes => implementation.appFilePickerNeedsBytes;

XFile? appXFileFromPlatformFile(PlatformFile file) =>
    implementation.appXFileFromPlatformFile(file);
