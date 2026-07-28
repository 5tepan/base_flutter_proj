import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/events/app_event.dart';
import 'package:base_flutter_proj/core/push/handler/push_registry.dart';
import 'package:base_flutter_proj/core/push/model/push_message.dart';

typedef PushEventEmitter = void Function(AppEvent event);

/// Маршрутизирует пуш в registry и эмитит [PushReceived] для loose coupling.
class PushDispatcher {
  PushDispatcher({
    required PushRegistry registry,
    PushEventEmitter? emitEvent,
  })  : _registry = registry,
        _emitEvent = emitEvent;

  final PushRegistry _registry;
  final PushEventEmitter? _emitEvent;

  bool dispatch(PushMessage message) {
    CustomLogger.info('Push received: $message');
    _emitEvent?.call(PushReceived(message));
    return _registry.dispatch(message);
  }
}
