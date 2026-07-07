import 'package:base_flutter_proj/core/websocket/model/websocket_channel_event.dart';

/// Описание подписки на канал и его события.
///
/// Для private-каналов Pusher на сервере к имени добавляется префикс `private-`.
class WebSocketChannelSubscription {
  const WebSocketChannelSubscription({
    required this.channelName,
    required this.eventHandlers,
    this.isPrivate = false,
  });

  final String channelName;
  final bool isPrivate;
  final Map<String, WebSocketEventHandler> eventHandlers;
}

/// Набор подписок фичи. Подключается в [webSocketHandlerModulesProvider].
class WebSocketHandlerModule {
  const WebSocketHandlerModule({
    this.subscriptions = const [],
  });

  final List<WebSocketChannelSubscription> subscriptions;

  bool get isEmpty => subscriptions.isEmpty;
}
