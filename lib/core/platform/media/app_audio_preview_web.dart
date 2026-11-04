import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

Widget appAudioPreview({
  required String path,
  XFile? file,
  required String title,
  required String unavailableMessage,
}) => Center(child: Text(unavailableMessage));
