class ListState<T> {
  final List<T> items;
  final bool isLoading;
  final bool isAllLoaded;
  final String? error;

  const ListState({
    this.items = const [],
    this.isLoading = false,
    this.isAllLoaded = false,
    this.error,
  });

  ListState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? isAllLoaded,
    String? error,
  }) {
    return ListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isAllLoaded: isAllLoaded ?? this.isAllLoaded,
      error: error,
    );
  }
}
