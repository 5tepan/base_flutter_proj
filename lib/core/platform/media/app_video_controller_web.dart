import 'package:cross_file/cross_file.dart';
import 'package:video_player/video_player.dart';

Future<VideoPlayerController?> createAppVideoController({
  XFile? file,
  String? path,
  String? url,
}) async {
  if (file != null) {
    final bytes = await file.readAsBytes();
    final mimeType = file.mimeType ?? 'application/octet-stream';
    final data = Uri.dataFromBytes(bytes, mimeType: mimeType).toString();
    return VideoPlayerController.networkUrl(Uri.parse(data));
  }
  if (url != null && url.isNotEmpty) {
    return VideoPlayerController.networkUrl(Uri.parse(url));
  }
  return null;
}
