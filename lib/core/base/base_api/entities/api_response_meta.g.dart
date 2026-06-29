// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponseMeta _$ApiResponseMetaFromJson(Map<String, dynamic> json) =>
    ApiResponseMeta(
      error: json['error'] as String?,
      invalidAccessToken: json['invalidAccessToken'] as bool?,
      success: json['success'] as bool?,
    );

Map<String, dynamic> _$ApiResponseMetaToJson(ApiResponseMeta instance) =>
    <String, dynamic>{
      'error': instance.error,
      'invalidAccessToken': instance.invalidAccessToken,
      'success': instance.success,
    };
