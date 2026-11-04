import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:video_player/video_player.dart';

Future<VideoPlayerController?> createAppVideoController({
  XFile? file,
  String? path,
  String? url,
}) async {
  final localPath = path ?? file?.path;
  if (localPath != null && localPath.isNotEmpty) {
    return VideoPlayerController.file(File(localPath));
  }
  if (url != null && url.isNotEmpty) {
    return VideoPlayerController.networkUrl(Uri.parse(url));
  }
  return null;
}
