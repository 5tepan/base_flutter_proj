/// Событие, полученное из WebSocket-канала.
class WebSocketChannelEvent {
  const WebSocketChannelEvent({
    required this.channel,
    required this.event,
    this.data,
  });

  final String channel;
  final String event;
  final Map<String, dynamic>? data;

  @override
  String toString() => 'WebSocketChannelEvent(channel: $channel, event: $event)';
}

typedef WebSocketEventHandler = void Function(WebSocketChannelEvent event);
