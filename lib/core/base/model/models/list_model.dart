import 'package:base_flutter_proj/core/base/model/models/base_model.dart';

abstract class ListModel<T> extends BaseModel {
  final List<T> items = [];

  bool isLoading = false;
  bool isAllLoaded = false;

  int _defaultPageSize = 0;

  Future<List<T>> loadNext(int offset);

  Future<List<T>> load() async {
    if (isLoading || isAllLoaded) return [];

    isLoading = true;

    try {
      final nextItems = await loadNext(items.length);

      if (nextItems.isNotEmpty) {
        items.addAll(nextItems);
        _defaultPageSize = nextItems.length;
      }

      isAllLoaded = nextItems.isEmpty || nextItems.length < _defaultPageSize;

      return nextItems;
    } catch (e) {
      setError(e);
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  void reset() {
    items.clear();
    isAllLoaded = false;
    clearError();
  }

  void replaceAll(List<T> newItems) {
    items
      ..clear()
      ..addAll(newItems);
  }

  void addItem(T item) {
    items.add(item);
  }

  void removeItem(T item) {
    items.remove(item);
  }
}
