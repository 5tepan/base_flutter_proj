import 'package:base_flutter_proj/core/base/model/models/list_model.dart';
import 'package:base_flutter_proj/core/base/model/states/list_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class ListNotifier<T> extends StateNotifier<ListState<T>> {
  final ListModel<T> model;
  ListNotifier(this.model) : super(const ListState());

  Future<void> loadNext() async {
    if (state.isLoading || state.isAllLoaded) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await model.load();
      state = state.copyWith(
        isLoading: false,
        items: [...state.items, ...items],
        isAllLoaded: model.isAllLoaded,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> reload() async {
    model.reset();
    state = const ListState();
    await loadNext();
  }
}
