import 'dart:convert';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:http/http.dart';
import 'package:talker/talker.dart';

const _encoder = JsonEncoder.withIndent('  ');

/// Базовый лог для HTTP-запросов/ответов
abstract class BaseHttpLog<T extends Object> extends TalkerLog {
  BaseHttpLog(super.message, {required this.data, this.responseBody});

  final T data;
  final String? responseBody;

  /// Цвет для конкретного типа лога
  @override
  AnsiPen get pen;

  /// Ключ для конкретного типа лога
  @override
  String get key;

  /// Название для вывода
  String get titleLog;

  /// HTTP-метод (если доступен)
  String? get method;

  /// HTTP-статус (если есть)
  int? get statusCode;

  /// Заголовки
  Map<String, String>? get headers;

  /// Тело запроса/ответа
  String get body {
    if (responseBody != null) {
      return extractBody(responseBody!);
    }
    return checkBody(data);
  }

  /// Curl команда (только для Request)
  String? get curl;

  @override
  String generateTextMessage({
    TimeFormat timeFormat = TimeFormat.timeAndSeconds,
  }) {
    var msg = '[$titleLog] [${method ?? "-"}] $message';

    if (statusCode != null) {
      msg += '\nStatus: $statusCode';
    }

    try {
      if (headers?.isNotEmpty ?? false) {
        final prettyHeaders = _encoder.convert(headers);
        msg += '\nHeaders: $prettyHeaders';
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

  String checkBody(T res) {
    switch (res) {
      case final Response res:
        return extractBody(res.body);
      case final Request res:
        return extractBody(res.body);
      case final MultipartRequest res:
        return extractBody(jsonEncode(res.fields), files: res.files);
      default:
        return "Данный тип запроса не поддерживает вывод тела";
    }
  }

  String extractBody(String body, {List<MultipartFile>? files}) {
    final contentLength = body.length;
    if (contentLength == 0) return '<Пустое тело запроса>';
    if (contentLength > 20000) return "<Большое тело запроса>";

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
              (e) => {
                'field': e.field,
                'filename': e.filename,
                'contentType': e.contentType.toString(),
              },
            )
            .toList();

        bodyJson = {...(bodyJson as Map), 'files': filesJson};
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
}
