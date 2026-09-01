/// Тип локального ассета для [AppIcon].
enum AppAssetKind {
  vector,
  raster,
}

/// Ссылка на локальный ассет (SVG или PNG).
class AppAsset {
  const AppAsset(this.path, this.kind);

  final String path;
  final AppAssetKind kind;

  bool get isVector => kind == AppAssetKind.vector;
  bool get isRaster => kind == AppAssetKind.raster;

  static const vector = AppAssetKind.vector;
  static const raster = AppAssetKind.raster;
}
