import 'package:flutter/foundation.dart';

@immutable
class PaginatedState<T> {
  const PaginatedState({
    this.items = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isAllLoaded = false,
    this.error,
  });

  final List<T> items;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isAllLoaded;
  final String? error;

  bool get hasError => error != null;
  bool get isEmpty => items.isEmpty;
  bool get showInitialLoading => isLoading && items.isEmpty;
  bool get showEmpty => isAllLoaded && items.isEmpty && error == null;

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isAllLoaded,
    String? error,
    bool clearError = false,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isAllLoaded: isAllLoaded ?? this.isAllLoaded,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
