// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppSettings _$AppSettingsFromJson(Map<String, dynamic> json) => AppSettings(
  pages: AppSettings._pagesFromJson(json['pages']),
  appStoreUrl: json['app_store_url'] as String?,
  googlePlayUrl: json['google_play_url'] as String?,
  codeLength: (json['code_length'] as num?)?.toInt() ?? 4,
);

Map<String, dynamic> _$AppSettingsToJson(AppSettings instance) =>
    <String, dynamic>{
      'pages': AppSettings._pagesToJson(instance.pages),
      'app_store_url': instance.appStoreUrl,
      'google_play_url': instance.googlePlayUrl,
      'code_length': instance.codeLength,
    };
