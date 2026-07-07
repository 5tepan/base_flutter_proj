import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';
import 'package:flutter/foundation.dart';

class _WebSocketHandlerKey {
  const _WebSocketHandlerKey(this.channel, this.event);

  final String channel;
  final String event;

  @override
  bool operator ==(Object other) {
    return other is _WebSocketHandlerKey &&
        other.channel == channel &&
        other.event == event;
  }

  @override
  int get hashCode => Object.hash(channel, event);
}

class WebSocketRegistry {
  WebSocketRegistry({
    List<WebSocketChannelSubscription>? subscriptions,
    Map<_WebSocketHandlerKey, WebSocketEventHandler>? handlers,
  })  : _subscriptions = List.unmodifiable(subscriptions ?? const []),
        _handlers = Map.unmodifiable(handlers ?? const {});

  factory WebSocketRegistry.fromModules(Iterable<WebSocketHandlerModule> modules) {
    final subscriptions = <WebSocketChannelSubscription>[];
    final handlers = <_WebSocketHandlerKey, WebSocketEventHandler>{};

    for (final module in modules) {
      for (final subscription in module.subscriptions) {
        subscriptions.add(subscription);
        for (final entry in subscription.eventHandlers.entries) {
          final key = _WebSocketHandlerKey(subscription.channelName, entry.key);
          _assertNoDuplicate(registry: handlers, key: key);
          handlers[key] = entry.value;
        }
      }
    }

    return WebSocketRegistry(
      subscriptions: subscriptions,
      handlers: handlers,
    );
  }

  final List<WebSocketChannelSubscription> _subscriptions;
  final Map<_WebSocketHandlerKey, WebSocketEventHandler> _handlers;

  List<WebSocketChannelSubscription> get subscriptions => _subscriptions;

  bool dispatch(WebSocketChannelEvent event) {
    final handler = _handlers[_WebSocketHandlerKey(event.channel, event.event)];
    if (handler == null) {
      CustomLogger.warning(
        'Unhandled WebSocket event: channel=${event.channel}, event=${event.event}',
      );
      return false;
    }

    handler(event);
    return true;
  }

  static void _assertNoDuplicate({
    required Map<_WebSocketHandlerKey, WebSocketEventHandler> registry,
    required _WebSocketHandlerKey key,
  }) {
    if (!kDebugMode || !registry.containsKey(key)) {
      return;
    }
    throw FlutterError(
      'Duplicate WebSocket handler: channel=${key.channel}, event=${key.event}',
    );
  }
}
