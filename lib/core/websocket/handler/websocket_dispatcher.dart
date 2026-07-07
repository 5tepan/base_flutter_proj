import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/events/app_event.dart';
import 'package:base_flutter_proj/core/websocket/handler/websocket_registry.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';

typedef WebSocketEventEmitter = void Function(AppEvent event);

/// Маршрутизирует WebSocket-события в registry и эмитит [WebSocketEventReceived].
class WebSocketDispatcher {
  WebSocketDispatcher({
    required WebSocketRegistry registry,
    WebSocketEventEmitter? emitEvent,
  })  : _registry = registry,
        _emitEvent = emitEvent;

  final WebSocketRegistry _registry;
  final WebSocketEventEmitter? _emitEvent;

  void dispatch(WebSocketChannelEvent event) {
    CustomLogger.info('WebSocket event received: $event');
    _emitEvent?.call(WebSocketEventReceived(event));
    _registry.dispatch(event);
  }
}
