import 'dart:convert';

import 'package:base_flutter_proj/core/push/push_delivery.dart';
import 'package:base_flutter_proj/core/push/push_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

abstract final class PushMessageParser {
  static const _typeKey = 'type';
  static const _dataKey = 'data';
  static const _topicKey = 'topic';
  static const _titleKey = 'title';
  static const _bodyKey = 'body';
  static const _fcmTopicPrefix = '/topics/';

  static PushMessage fromRemoteMessage(
    RemoteMessage message, {
    required PushDelivery delivery,
  }) {
    final raw = Map<String, dynamic>.from(message.data);
    final notification = message.notification;
    if (notification?.title != null) {
      raw.putIfAbsent(_titleKey, () => notification!.title);
    }
    if (notification?.body != null) {
      raw.putIfAbsent(_bodyKey, () => notification!.body);
    }

    final topic = extractTopicFromSender(message.from) ??
        parseString(raw[_topicKey]);

    return parse(
      raw: raw,
      delivery: delivery,
      topic: topic,
      messageId: message.messageId,
    );
  }

  static PushMessage parse({
    required Map<String, dynamic> raw,
    required PushDelivery delivery,
    String? topic,
    String? messageId,
  }) {
    final normalized = _normalizeMap(raw);
    final type = extractType(normalized);
    final data = extractData(normalized);
    final resolvedTopic = topic ?? parseString(normalized[_topicKey]);

    return PushMessage(
      type: type,
      data: data,
      topic: resolvedTopic,
      title: parseString(normalized[_titleKey]),
      body: parseString(normalized[_bodyKey]),
      messageId: messageId,
      delivery: delivery,
      raw: normalized,
    );
  }

  static String? extractTopicFromSender(String? from) {
    if (from == null || !from.startsWith(_fcmTopicPrefix)) {
      return null;
    }
    return from.substring(_fcmTopicPrefix.length);
  }

  static int? extractType(Map<String, dynamic> payload) {
    final rootType = parseInt(payload[_typeKey]);
    if (rootType != null) {
      return rootType;
    }

    final nested = _decodeIfJson(payload[_dataKey]);
    if (nested is Map<String, dynamic>) {
      return parseInt(nested[_typeKey]);
    }

    return null;
  }

  static Map<String, dynamic> extractData(Map<String, dynamic> payload) {
    final explicit = _decodeIfJson(payload[_dataKey]);

    final Map<String, dynamic> data;
    if (explicit is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(explicit);
    } else if (explicit != null) {
      data = {'value': explicit};
    } else {
      data = Map<String, dynamic>.from(payload)
        ..remove(_typeKey)
        ..remove(_dataKey)
        ..remove(_topicKey)
        ..remove(_titleKey)
        ..remove(_bodyKey);
    }

    data.remove(_typeKey);
    return _normalizeMap(data);
  }

  static int? parseInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value.trim());
    }
    return null;
  }

  static String? parseString(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return value.toString();
  }

  static dynamic _decodeIfJson(dynamic value) {
    if (value is Map) {
      return _normalizeMap(Map<String, dynamic>.from(value));
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.startsWith('{') || trimmed.startsWith('[')) {
        try {
          return jsonDecode(trimmed);
        } catch (_) {
          return value;
        }
      }
    }
    return value;
  }

  static Map<String, dynamic> _normalizeMap(Map<String, dynamic> source) {
    return source.map((key, value) {
      final decoded = _decodeIfJson(value);
      if (decoded is Map) {
        return MapEntry(key, _normalizeMap(Map<String, dynamic>.from(decoded)));
      }
      return MapEntry(key, decoded);
    });
  }
}
