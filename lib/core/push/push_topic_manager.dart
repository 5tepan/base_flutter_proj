import 'package:base_flutter_proj/core/push/push_service.dart';

/// Удобная обёртка для подписки на FCM topics из фич.
class PushTopicManager {
  PushTopicManager(this._service);

  final PushService _service;

  Future<void> subscribe(String topic) => _service.subscribeToTopic(topic);

  Future<void> unsubscribe(String topic) => _service.unsubscribeFromTopic(topic);

  Future<void> syncTopics({
    required Set<String> desired,
    required Set<String> current,
  }) async {
    final toSubscribe = desired.difference(current);
    final toUnsubscribe = current.difference(desired);

    for (final topic in toSubscribe) {
      await subscribe(topic);
    }
    for (final topic in toUnsubscribe) {
      await unsubscribe(topic);
    }
  }
}
