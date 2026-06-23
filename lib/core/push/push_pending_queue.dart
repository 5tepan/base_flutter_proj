import 'package:base_flutter_proj/core/push/push_message.dart';

/// Очередь пушей из background isolate для обработки после старта UI.
abstract final class PushPendingQueue {
  static final List<PushMessage> _pending = [];

  static List<PushMessage> get pending => List.unmodifiable(_pending);

  static void enqueue(PushMessage message) {
    _pending.add(message);
  }

  static List<PushMessage> drain() {
    if (_pending.isEmpty) {
      return const [];
    }
    final messages = List<PushMessage>.from(_pending);
    _pending.clear();
    return messages;
  }
}
