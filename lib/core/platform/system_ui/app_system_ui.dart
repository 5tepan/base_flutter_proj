import 'package:base_flutter_proj/core/platform/system_ui/app_system_ui_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/system_ui/app_system_ui_io.dart'
    as implementation;

Future<void> enterGalleryMode() => implementation.enterGalleryMode();

Future<void> restoreAfterGallery() => implementation.restoreAfterGallery();
