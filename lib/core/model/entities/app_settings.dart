import 'package:base_flutter_proj/core/model/entities/info_page_holder.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_settings.g.dart';

/// Настройки приложения, загружаемые с сервера при старте.
@JsonSerializable(fieldRename: FieldRename.snake)
class AppSettings {
  const AppSettings({
    this.pages,
    this.appStoreUrl,
    this.googlePlayUrl,
    this.codeLength = 4,
  });

  static const defaults = AppSettings();

  @JsonKey(fromJson: _pagesFromJson, toJson: _pagesToJson)
  final InfoPageHolder? pages;
  final String? appStoreUrl;
  final String? googlePlayUrl;
  final int codeLength;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$AppSettingsToJson(this);

  factory AppSettings.fromApiJson(Map<String, dynamic> json) =>
      AppSettings.fromJson(json);

  static InfoPageHolder? _pagesFromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      return null;
    }
    return InfoPageHolder.fromJson(json);
  }

  static Object? _pagesToJson(InfoPageHolder? pages) => pages?.toJson();
}
