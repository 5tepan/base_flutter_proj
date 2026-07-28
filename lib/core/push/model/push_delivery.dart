/// Как пуш был доставлен в приложение.
enum PushDelivery {
  /// Приложение на переднем плане — [FirebaseMessaging.onMessage].
  foreground,

  /// Тап по уведомлению, приложение было в фоне.
  openedApp,

  /// Тап по уведомлению при холодном старте.
  openedFromTerminated,

  /// Data-only пуш в фоне (background isolate).
  backgroundData,

  /// Пуш пришёл по подписке на topic (метаданные доставки).
  topic,
  ;

  bool get isUserInteraction =>
      this == openedApp || this == openedFromTerminated;

  bool get isForeground => this == foreground;
}
