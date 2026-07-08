/// Имена каналов WebSocket для чатов.
///
/// Для private-каналов Pusher клиент добавляет префикс `private-`.
abstract final class ChatSocketChannels {
  static const message = 'chat.message';
}

/// Имена событий WebSocket для чатов.
abstract final class ChatSocketEvents {
  static const messageSent = 'message.sent';
  static const messageRead = 'message.read';
  static const typingStart = 'typing.start';
  static const typingStop = 'typing.stop';
}
