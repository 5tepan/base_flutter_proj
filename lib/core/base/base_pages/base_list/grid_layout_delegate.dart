class GridLayoutDelegate {
  const GridLayoutDelegate({
    required this.gridWidth,
    this.gridItemHeight = 300,
    this.gridItemRatio,
    this.crossAxisSpacing = 10,
    this.mainAxisSpacing = 10,
    this.axisCount = 2,
    this.fixedTopHeightItemRatio,
    this.fixedBottomItemHeight,
  });

  final double gridWidth;
  final double gridItemHeight;
  final double? gridItemRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int axisCount;
  final double? fixedTopHeightItemRatio;
  final double? fixedBottomItemHeight;

  double get childAspectRatio {
    if (gridItemRatio != null) {
      return gridItemRatio!;
    }

    final gridItemWidth =
        (gridWidth - (axisCount - 1) * crossAxisSpacing) / axisCount;

    if (fixedBottomItemHeight != null && fixedTopHeightItemRatio != null) {
      return gridItemWidth /
          ((gridItemWidth * fixedTopHeightItemRatio!) + fixedBottomItemHeight!);
    }

    return gridItemWidth / gridItemHeight;
  }
}
