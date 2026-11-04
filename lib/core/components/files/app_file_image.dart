import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';

import 'package:base_flutter_proj/core/platform/files/app_file_image_provider.dart';

class AppFileImage extends StatefulWidget {
  const AppFileImage({
    required this.path,
    super.key,
    this.file,
    this.fit = BoxFit.contain,
    this.errorBuilder,
  });

  final String path;
  final XFile? file;
  final BoxFit fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  State<AppFileImage> createState() => _AppFileImageState();
}

class _AppFileImageState extends State<AppFileImage> {
  late Future<ImageProvider<Object>> _provider;

  @override
  void initState() {
    super.initState();
    _loadProvider();
  }

  @override
  void didUpdateWidget(covariant AppFileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.path != widget.path || oldWidget.file != widget.file) {
      _loadProvider();
    }
  }

  void _loadProvider() {
    _provider = appFileImageProvider(widget.file ?? XFile(widget.path));
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ImageProvider<Object>>(
    future: _provider,
    builder: (context, snapshot) {
      final provider = snapshot.data;
      if (provider == null) {
        return widget.errorBuilder?.call(
              context,
              snapshot.error ?? StateError('Image unavailable'),
              snapshot.stackTrace,
            ) ??
            const Center(child: CircularProgressIndicator());
      }
      return Image(
        image: provider,
        fit: widget.fit,
        errorBuilder: widget.errorBuilder,
      );
    },
  );
}
