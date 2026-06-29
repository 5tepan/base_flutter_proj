// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => AuthSession(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  phoneNumber: json['phoneNumber'] as String,
  expiresAt: const DateTimeJsonConverter().fromJson(json['expiresAt']),
);

Map<String, dynamic> _$AuthSessionToJson(AuthSession instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'phoneNumber': instance.phoneNumber,
      'expiresAt': const DateTimeJsonConverter().toJson(instance.expiresAt),
    };
