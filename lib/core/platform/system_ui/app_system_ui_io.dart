import 'package:flutter/services.dart';

Future<void> enterGalleryMode() =>
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

Future<void> restoreAfterGallery() =>
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
