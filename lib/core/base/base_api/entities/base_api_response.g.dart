// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseApiResponse _$BaseApiResponseFromJson(Map<String, dynamic> json) =>
    BaseApiResponse(
      meta: json['meta'] == null
          ? null
          : ApiResponseMeta.fromJson(json['meta'] as Map<String, dynamic>),
      rawData: json['rawData'] as String?,
      errorCode: $enumDecodeNullable(_$AppErrorCodeEnumMap, json['errorCode']),
      serverMessage: json['serverMessage'] as String?,
      dataJson: json['dataJson'],
    );

Map<String, dynamic> _$BaseApiResponseToJson(BaseApiResponse instance) =>
    <String, dynamic>{
      'meta': instance.meta,
      'rawData': instance.rawData,
      'errorCode': _$AppErrorCodeEnumMap[instance.errorCode],
      'serverMessage': instance.serverMessage,
      'dataJson': instance.dataJson,
    };

const _$AppErrorCodeEnumMap = {
  AppErrorCode.noInternet: 'noInternet',
  AppErrorCode.connectionError: 'connectionError',
  AppErrorCode.unknownError: 'unknownError',
  AppErrorCode.requestFailed: 'requestFailed',
  AppErrorCode.dataNotFound: 'dataNotFound',
  AppErrorCode.parseError: 'parseError',
  AppErrorCode.missingMeta: 'missingMeta',
  AppErrorCode.missingData: 'missingData',
  AppErrorCode.invalidMeta: 'invalidMeta',
  AppErrorCode.badRequestFormat: 'badRequestFormat',
  AppErrorCode.invalidJson: 'invalidJson',
  AppErrorCode.phoneRequired: 'phoneRequired',
  AppErrorCode.invalidConfirmationCode: 'invalidConfirmationCode',
  AppErrorCode.sessionExpired: 'sessionExpired',
  AppErrorCode.sendCodeFailed: 'sendCodeFailed',
  AppErrorCode.verifyCodeFailed: 'verifyCodeFailed',
  AppErrorCode.resendCodeFailed: 'resendCodeFailed',
  AppErrorCode.refreshSessionFailed: 'refreshSessionFailed',
  AppErrorCode.dateOfBirthRequired: 'dateOfBirthRequired',
  AppErrorCode.nameRequired: 'nameRequired',
  AppErrorCode.surnameRequired: 'surnameRequired',
  AppErrorCode.fioRequired: 'fioRequired',
  AppErrorCode.fieldRequired: 'fieldRequired',
  AppErrorCode.phoneInvalid: 'phoneInvalid',
  AppErrorCode.codeRequired: 'codeRequired',
  AppErrorCode.passwordMinLength: 'passwordMinLength',
  AppErrorCode.emailRequired: 'emailRequired',
  AppErrorCode.emailInvalid: 'emailInvalid',
  AppErrorCode.passwordMismatch: 'passwordMismatch',
  AppErrorCode.sendMessageFailed: 'sendMessageFailed',
};
