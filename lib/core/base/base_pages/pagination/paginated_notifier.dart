import 'package:base_flutter_proj/core/base/base_pages/pagination/paginated_state.dart';
import 'package:base_flutter_proj/core/errors/error_mapper.dart';
import 'package:base_flutter_proj/core/helpers/async_executor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Стандартный паттерн пагинации в проекте.
/// Наследуйте для списков с подгрузкой страниц.
abstract class PaginatedNotifier<T> extends Notifier<PaginatedState<T>> {
  final AsyncExecutor _executor = AsyncExecutor();

  @override
  PaginatedState<T> build() {
    ref.onDispose(_executor.invalidate);
    Future.microtask(loadInitial);
    return PaginatedState<T>();
  }

  int get pageSize => 20;

  int _page = 0;
  bool _requestInProgress = false;

  Future<List<T>> loadPage(int page);

  Future<void> loadInitial() async {
    if (_requestInProgress) return;

    final generation = _executor.capture();
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
      if (!_executor.isCurrentGeneration(generation)) return;

      state = state.copyWith(
        items: items,
        isLoading: false,
        isAllLoaded: items.length < pageSize,
      );
    } catch (error) {
      if (!_executor.isCurrentGeneration(generation)) return;
      final mapped = ErrorMapper.from(error);
      state = state.copyWith(
        isLoading: false,
        errorCode: mapped.code,
        serverMessage: mapped.serverMessage,
      );
    } finally {
      if (_executor.isCurrentGeneration(generation)) {
        _requestInProgress = false;
      }
    }
  }

  Future<void> reload() async {
    if (_requestInProgress) return;

    final generation = _executor.capture();
    _requestInProgress = true;
    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      _page = 0;
      final items = await loadPage(_page);
      if (!_executor.isCurrentGeneration(generation)) return;

      state = state.copyWith(
        items: items,
        isRefreshing: false,
        isAllLoaded: items.length < pageSize,
      );
    } catch (error) {
      if (!_executor.isCurrentGeneration(generation)) return;
      final mapped = ErrorMapper.from(error);
      state = state.copyWith(
        isRefreshing: false,
        errorCode: mapped.code,
        serverMessage: mapped.serverMessage,
      );
    } finally {
      if (_executor.isCurrentGeneration(generation)) {
        _requestInProgress = false;
      }
    }
  }

  Future<void> loadMore() async {
    if (_requestInProgress ||
        state.isAllLoaded ||
        (state.items.isEmpty && state.isLoading)) {
      return;
    }

    final generation = _executor.capture();
    _requestInProgress = true;
    state = state.copyWith(isLoadingMore: true, clearError: true);

    try {
      final nextPage = _page + 1;
      final nextItems = await loadPage(nextPage);
      if (!_executor.isCurrentGeneration(generation)) return;

      _page = nextPage;

      state = state.copyWith(
        items: [...state.items, ...nextItems],
        isLoadingMore: false,
        isAllLoaded: nextItems.length < pageSize,
      );
    } catch (error) {
      if (!_executor.isCurrentGeneration(generation)) return;
      final mapped = ErrorMapper.from(error);
      state = state.copyWith(
        isLoadingMore: false,
        errorCode: mapped.code,
        serverMessage: mapped.serverMessage,
      );
    } finally {
      if (_executor.isCurrentGeneration(generation)) {
        _requestInProgress = false;
      }
    }
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}
