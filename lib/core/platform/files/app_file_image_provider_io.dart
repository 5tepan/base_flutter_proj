import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/painting.dart';

Future<ImageProvider<Object>> appFileImageProvider(XFile file) async =>
    FileImage(File(file.path));
