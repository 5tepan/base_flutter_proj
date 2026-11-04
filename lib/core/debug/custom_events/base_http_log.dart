import 'dart:convert';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/debug/sensitive_log_redaction.dart';
import 'package:dio/dio.dart';
import 'package:talker/talker.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// Базовый лог для HTTP-запросов/ответов.
abstract class BaseHttpLog<T extends Object> extends TalkerLog {
  BaseHttpLog(super.message, {required this.data, this.responseBody});

  final T data;
  final String? responseBody;

  @override
  AnsiPen get pen;

  @override
  String get key;

  String get titleLog;
  String? get method;
  int? get statusCode;
  Map<String, String>? get headers;
  String? get curl;

  String get body =>
      responseBody != null ? extractBody(responseBody!) : checkBody(data);

  @override
  String generateTextMessage({
    TimeFormat timeFormat = TimeFormat.timeAndSeconds,
  }) {
    var msg = '[$titleLog] [${method ?? "-"}] $message';

    if (statusCode != null) {
      msg += '\nStatus: $statusCode';
    }

    try {
      final safeHeaders = headers == null
          ? null
          : SensitiveLogRedaction.headers(headers!);
      if (safeHeaders?.isNotEmpty ?? false) {
        msg += '\nHeaders: ${_encoder.convert(safeHeaders)}';
      }
      msg += '\nBody: $body';
      if (curl != null) {
        msg += '\nCurl: $curl';
      }
    } catch (e, s) {
      CustomLogger.error('[$runtimeType] Ошибка логгера', e, s);
    }
    return msg;
  }

  String checkBody(T value) {
    if (value is Response) {
      return extractBody(_encode(value.data));
    }
    if (value is RequestOptions) {
      final requestData = value.data;
      if (requestData is FormData) {
        return extractBody(
          jsonEncode(Map.fromEntries(requestData.fields)),
          files: requestData.files,
        );
      }
      return extractBody(_encode(requestData));
    }
    return 'Данный тип запроса не поддерживает вывод тела';
  }

  String extractBody(
    String body, {
    List<MapEntry<String, MultipartFile>>? files,
  }) {
    if (body.isEmpty) return '<Пустое тело запроса>';
    if (body.length > 20000) return '<Большое тело запроса>';

    try {
      dynamic bodyJson;
      try {
        bodyJson = jsonDecode(body);
      } catch (_) {
        bodyJson = smartParseBody(body);
      }

      if (files?.isNotEmpty ?? false) {
        final filesJson = files!
            .map(
              (entry) => {
                'field': entry.key,
                'filename': entry.value.filename,
                'contentType': entry.value.contentType.toString(),
              },
            )
            .toList();

        bodyJson = {if (bodyJson is Map) ...bodyJson, 'files': filesJson};
      }

      return _encoder.convert(bodyJson);
    } catch (_) {
      return body;
    }
  }

  dynamic smartParseBody(String body) {
    final parsed = Uri.splitQueryString(body);
    return parsed.map((key, value) {
      try {
        return MapEntry(key, jsonDecode(value));
      } catch (_) {
        return MapEntry(key, value);
      }
    });
  }

  String _encode(Object? value) {
    if (value == null) return '';
    if (value is String) return value;
    return jsonEncode(value);
  }

  Map<String, String> stringHeaders(Map<String, dynamic> values) => values.map(
    (key, value) =>
        MapEntry(key, value is Iterable ? value.join(', ') : '$value'),
  );
}
