import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PaginatedNotifier<T> extends Notifier<PaginatedState<T>> {
  @override
  PaginatedState<T> build() {
    Future.microtask(loadInitial);
    return PaginatedState<T>();
  }

  int get pageSize => 20;

  int _page = 0;
  bool _requestInProgress = false;

  Future<List<T>> loadPage(int page);

  Future<void> loadInitial() async {
    if (_requestInProgress) return;

    _requestInProgress = true;
    state = state.copyWith(
      isLoading: true,
      clearError: true,
      isAllLoaded: false,
      items: [],
    );

    try {
      _page = 0;
      final items = await loadPage(_page);

      state = state.copyWith(
        items: items,
        isLoading: false,
        isAllLoaded: items.length < pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    } finally {
      _requestInProgress = false;
    }
  }

  Future<void> reload() async {
    if (_requestInProgress) return;

    _requestInProgress = true;
    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      _page = 0;
      final items = await loadPage(_page);

      state = state.copyWith(
        items: items,
        isRefreshing: false,
        isAllLoaded: items.length < pageSize,
      );
    } catch (e) {
      state = state.copyWith(isRefreshing: false, error: e.toString());
    } finally {
      _requestInProgress = false;
    }
  }

  Future<void> loadMore() async {
    if (_requestInProgress ||
        state.isAllLoaded ||
        (state.items.isEmpty && state.isLoading)) {
      return;
    }

    _requestInProgress = true;
    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final nextPage = _page + 1;
      final nextItems = await loadPage(nextPage);

      _page = nextPage;

      state = state.copyWith(
        items: [...state.items, ...nextItems],
        isLoadingMore: false,
        isAllLoaded: nextItems.length < pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false, error: e.toString());
    } finally {
      _requestInProgress = false;
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
