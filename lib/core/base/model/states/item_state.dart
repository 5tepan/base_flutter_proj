class ItemState<T> {
  final T? item;
  final bool isLoading;
  final String? error;

  const ItemState({this.item, this.isLoading = false, this.error});

  ItemState<T> copyWith({T? item, bool? isLoading, String? error}) {
    return ItemState(
      item: item ?? this.item,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
