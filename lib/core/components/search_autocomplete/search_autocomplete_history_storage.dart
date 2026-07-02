/// Хранилище истории поиска для [SearchAutocompleteField].
///
/// Реализации:
/// - [InMemorySearchAutocompleteHistoryStorage] — по умолчанию в виджете
/// - [HiveSearchAutocompleteHistoryStorage] — persistent через Hive
/// - [CallbackSearchAutocompleteHistoryStorage] — кастомный backend
abstract class SearchAutocompleteHistoryStorage {
  const SearchAutocompleteHistoryStorage();

  Future<List<String>> read(String storageKey);

  Future<void> write(String storageKey, List<String> items);

  Future<void> clear(String storageKey);
}

/// In-memory реализация (по умолчанию, пока экран живёт).
class InMemorySearchAutocompleteHistoryStorage
    extends SearchAutocompleteHistoryStorage {
  InMemorySearchAutocompleteHistoryStorage();

  static final Map<String, List<String>> _store = {};

  @override
  Future<List<String>> read(String storageKey) async {
    return List<String>.from(_store[storageKey] ?? const []);
  }

  @override
  Future<void> write(String storageKey, List<String> items) async {
    _store[storageKey] = List<String>.from(items);
  }

  @override
  Future<void> clear(String storageKey) async {
    _store.remove(storageKey);
  }
}

/// Делегат для подключения другого persistent storage.
class CallbackSearchAutocompleteHistoryStorage
    extends SearchAutocompleteHistoryStorage {
  const CallbackSearchAutocompleteHistoryStorage({
    required this.readItems,
    required this.writeItems,
    this.clearItems,
  });

  final Future<List<String>> Function(String storageKey) readItems;
  final Future<void> Function(String storageKey, List<String> items) writeItems;
  final Future<void> Function(String storageKey)? clearItems;

  @override
  Future<List<String>> read(String storageKey) => readItems(storageKey);

  @override
  Future<void> write(String storageKey, List<String> items) =>
      writeItems(storageKey, items);

  @override
  Future<void> clear(String storageKey) async {
    final clearItems = this.clearItems;
    if (clearItems != null) {
      await clearItems(storageKey);
    }
  }
}
