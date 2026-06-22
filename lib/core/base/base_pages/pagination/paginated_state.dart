import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:flutter/foundation.dart';

@immutable
class PaginatedState<T> {
  const PaginatedState({
    this.items = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.isAllLoaded = false,
    this.errorCode,
    this.serverMessage,
  });

  final List<T> items;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool isAllLoaded;
  final AppErrorCode? errorCode;
  final String? serverMessage;

  bool get hasError => errorCode != null;
  bool get isEmpty => items.isEmpty;
  bool get showInitialLoading => isLoading && items.isEmpty;
  bool get showEmpty => isAllLoaded && items.isEmpty && !hasError;

  PaginatedState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? isAllLoaded,
    AppErrorCode? errorCode,
    String? serverMessage,
    bool clearError = false,
  }) {
    return PaginatedState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isAllLoaded: isAllLoaded ?? this.isAllLoaded,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      serverMessage: clearError ? null : (serverMessage ?? this.serverMessage),
    );
  }
}
