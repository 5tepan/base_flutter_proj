import 'package:base_flutter_proj/core/base/model/models/list_model.dart';
import 'package:base_flutter_proj/core/base/model/states/list_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ListNotifier<T> extends Notifier<ListState<T>> {
  ListModel<T> get model;

  @override
  ListState<T> build() => const ListState();

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
