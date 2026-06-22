/// Защита async-операций в notifier от гонок после dispose / повторного вызова.
class AsyncExecutor {
  int _generation = 0;

  void invalidate() {
    _generation++;
  }

  int capture() => _generation;

  bool isCurrentGeneration(int captured) => captured == _generation;
}
