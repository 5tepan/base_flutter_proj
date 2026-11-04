import 'package:base_flutter_proj/core/platform/media/app_audio_preview_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/media/app_audio_preview_io.dart'
    as implementation;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

Widget appAudioPreview({
  required String path,
  XFile? file,
  required String title,
  required String unavailableMessage,
}) => implementation.appAudioPreview(
  path: path,
  file: file,
  title: title,
  unavailableMessage: unavailableMessage,
);
