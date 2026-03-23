class PaginationController {
  const PaginationController({this.infinityScrollOffset = 6});

  final int infinityScrollOffset;

  bool shouldLoadMore({
    required int renderedItemIndex,
    required int itemsLength,
    required bool isAllLoaded,
    required bool isLoadingMore,
    required bool isLoading,
  }) {
    if (isAllLoaded || isLoadingMore || isLoading) {
      return false;
    }

    return renderedItemIndex >= (itemsLength - infinityScrollOffset);
  }
}
