import 'package:base_flutter_proj/core/push/push_delivery.dart';
import 'package:base_flutter_proj/core/push/push_message.dart';

typedef PushTypeHandler = void Function(
  PushMessage message,
  PushDelivery delivery,
);

typedef PushTopicHandler = void Function(
  PushMessage message,
  PushDelivery delivery,
);

/// Набор обработчиков фичи. Подключается в [pushHandlerModulesProvider].
///
/// Ключи [typeHandlers] — константы из [PushType].
/// Ключи [topicHandlers] — константы из [PushTopic].
class PushHandlerModule {
  const PushHandlerModule({
    this.typeHandlers = const {},
    this.topicHandlers = const {},
  });

  final Map<int, PushTypeHandler> typeHandlers;
  final Map<String, PushTopicHandler> topicHandlers;

  bool get isEmpty => typeHandlers.isEmpty && topicHandlers.isEmpty;
}
