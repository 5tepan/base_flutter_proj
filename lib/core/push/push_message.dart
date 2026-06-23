import 'package:base_flutter_proj/core/push/push_delivery.dart';
import 'package:base_flutter_proj/core/push/push_message_parser.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Нормализованный пуш для обработки в фичах.
class PushMessage {
  const PushMessage({
    required this.delivery,
    this.type,
    this.data = const {},
    this.topic,
    this.title,
    this.body,
    this.messageId,
    this.raw = const {},
  });

  /// Числовой тип пуша. `null`, если не удалось распарсить.
  final int? type;

  /// Полезная нагрузка (без поля `type`).
  final Map<String, dynamic> data;

  /// Topic FCM, если пуш пришёл по подписке или указан в payload.
  final String? topic;

  final String? title;
  final String? body;
  final String? messageId;
  final PushDelivery delivery;

  /// Исходный payload до нормализации (для отладки).
  final Map<String, dynamic> raw;

  factory PushMessage.fromRemoteMessage(
    RemoteMessage message, {
    required PushDelivery delivery,
  }) {
    return PushMessageParser.fromRemoteMessage(message, delivery: delivery);
  }

  factory PushMessage.fromMap(
    Map<String, dynamic> raw, {
    required PushDelivery delivery,
    String? topic,
    String? messageId,
  }) {
    return PushMessageParser.parse(
      raw: raw,
      delivery: delivery,
      topic: topic,
      messageId: messageId,
    );
  }

  T? dataValue<T>(String key) {
    final value = data[key];
    if (value is T) {
      return value;
    }
    return null;
  }

  String? dataString(String key) {
    final value = data[key];
    if (value == null) {
      return null;
    }
    return value.toString();
  }

  int? dataInt(String key) => PushMessageParser.parseInt(data[key]);

  @override
  String toString() =>
      'PushMessage(type: $type, topic: $topic, delivery: $delivery, data: $data)';
}
