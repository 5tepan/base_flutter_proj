import 'package:base_flutter_proj/core/base/model/models/base_data_model.dart';

abstract class ItemModel<T> extends BaseDataModel<T> {
  T? get item => data;

  bool get isLoaded => data != null;

  @override
  Future<T> load() async {
    if (isLoading) return data as T;

    isLoading = true;

    try {
      final result = await loadItem();
      data = result;
      return result;
    } catch (e) {
      setError(e);
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<T> loadItem();
}
