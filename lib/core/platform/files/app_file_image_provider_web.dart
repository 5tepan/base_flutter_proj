import 'package:cross_file/cross_file.dart';
import 'package:flutter/painting.dart';

Future<ImageProvider<Object>> appFileImageProvider(XFile file) async =>
    MemoryImage(await file.readAsBytes());
