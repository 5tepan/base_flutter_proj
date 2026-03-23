import 'package:base_flutter_proj/core/base/model/models/item_model.dart';
import 'package:base_flutter_proj/core/base/model/states/item_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ItemNotifier<T> extends StateNotifier<ItemState<T>> {
  final ItemModel<T> model;
  ItemNotifier(this.model) : super(const ItemState());

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final item = await model.load();
      state = state.copyWith(item: item, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
