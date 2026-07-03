import 'package:cross_file/cross_file.dart';

/// Универсальное представление файла для загрузки и просмотра.
class AppFileItem {
  AppFileItem({
    required this.id,
    required this.name,
    this.localPath,
    this.remoteUrl,
    this.sizeBytes,
    this.mimeType,
    this.localFile,
  }) : assert(
         localPath != null ||
             localFile != null ||
             (remoteUrl != null && remoteUrl.isNotEmpty),
         'Нужен localPath, localFile или remoteUrl.',
       );

  final String id;
  final String name;
  final String? localPath;
  final String? remoteUrl;
  final int? sizeBytes;
  final String? mimeType;
  final XFile? localFile;

  String? get resolvedPath => localPath ?? localFile?.path;

  bool get hasLocalSource => resolvedPath?.isNotEmpty ?? false;

  AppFileItem copyWith({
    String? id,
    String? name,
    String? localPath,
    String? remoteUrl,
    int? sizeBytes,
    String? mimeType,
    XFile? localFile,
  }) {
    return AppFileItem(
      id: id ?? this.id,
      name: name ?? this.name,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      mimeType: mimeType ?? this.mimeType,
      localFile: localFile ?? this.localFile,
    );
  }
}
