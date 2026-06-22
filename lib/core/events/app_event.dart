/// События приложения. Эмит через [appEventProvider], подписка через `ref.listen`.
sealed class AppEvent {
  const AppEvent();
}

final class AppLifecyclePaused extends AppEvent {
  const AppLifecyclePaused();
}

final class AppLifecycleResumed extends AppEvent {
  const AppLifecycleResumed();
}

final class AppNetworkRestored extends AppEvent {
  const AppNetworkRestored();
}

final class AppNetworkLost extends AppEvent {
  const AppNetworkLost();
}

/// Перезагрузка данных приложения (например, после смены окружения).
final class AppReloadRequested extends AppEvent {
  const AppReloadRequested();
}

/// Перезапуск карты / тяжёлого виджета.
final class AppMapRerunRequested extends AppEvent {
  const AppMapRerunRequested();
}
