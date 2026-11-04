import 'package:cross_file/cross_file.dart';
import 'package:video_player/video_player.dart';

import 'package:base_flutter_proj/core/platform/media/app_video_controller_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/media/app_video_controller_io.dart'
    as implementation;

Future<VideoPlayerController?> createAppVideoController({
  XFile? file,
  String? path,
  String? url,
}) => implementation.createAppVideoController(file: file, path: path, url: url);
