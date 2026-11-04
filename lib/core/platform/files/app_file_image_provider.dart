import 'package:base_flutter_proj/core/platform/files/app_file_image_provider_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/files/app_file_image_provider_io.dart'
    as implementation;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/painting.dart';

Future<ImageProvider<Object>> appFileImageProvider(XFile file) =>
    implementation.appFileImageProvider(file);
