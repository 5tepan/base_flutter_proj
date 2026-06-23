import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/push/push_handler_module.dart';
import 'package:base_flutter_proj/core/push/push_message.dart';
import 'package:flutter/foundation.dart';

class PushRegistry {
  PushRegistry({
    Map<int, PushTypeHandler>? typeHandlers,
    Map<String, PushTopicHandler>? topicHandlers,
  })  : _typeHandlers = Map.unmodifiable(typeHandlers ?? const {}),
        _topicHandlers = Map.unmodifiable(topicHandlers ?? const {});

  factory PushRegistry.fromModules(Iterable<PushHandlerModule> modules) {
    final typeHandlers = <int, PushTypeHandler>{};
    final topicHandlers = <String, PushTopicHandler>{};

    for (final module in modules) {
      for (final entry in module.typeHandlers.entries) {
        _assertNoDuplicate(
          registry: typeHandlers,
          key: entry.key,
          label: 'push type',
        );
        typeHandlers[entry.key] = entry.value;
      }
      for (final entry in module.topicHandlers.entries) {
        _assertNoDuplicate(
          registry: topicHandlers,
          key: entry.key,
          label: 'push topic',
        );
        topicHandlers[entry.key] = entry.value;
      }
    }

    return PushRegistry(
      typeHandlers: typeHandlers,
      topicHandlers: topicHandlers,
    );
  }

  final Map<int, PushTypeHandler> _typeHandlers;
  final Map<String, PushTopicHandler> _topicHandlers;

  bool dispatch(PushMessage message) {
    var handled = false;

    final topic = message.topic;
    if (topic != null) {
      final topicHandler = _topicHandlers[topic];
      if (topicHandler != null) {
        topicHandler(message, message.delivery);
        handled = true;
      }
    }

    final type = message.type;
    if (type != null) {
      final typeHandler = _typeHandlers[type];
      if (typeHandler != null) {
        typeHandler(message, message.delivery);
        handled = true;
      }
    }

    if (!handled) {
      CustomLogger.warning(
        'Unhandled push: type=$type, topic=$topic, delivery=${message.delivery}',
      );
    }

    return handled;
  }

  static void _assertNoDuplicate<K>({
    required Map<K, dynamic> registry,
    required K key,
    required String label,
  }) {
    if (!kDebugMode || !registry.containsKey(key)) {
      return;
    }
    throw FlutterError(
      'Duplicate $label handler: $key. '
      'Use constants from PushType / PushTopic only.',
    );
  }
}
