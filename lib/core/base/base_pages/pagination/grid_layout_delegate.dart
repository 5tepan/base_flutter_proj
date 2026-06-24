import 'package:flutter/material.dart';

/// Параметры сетки для [PaginatedGridView].
class GridLayoutDelegate {
  const GridLayoutDelegate({
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 10,
    this.crossAxisSpacing = 10,
    this.childAspectRatio = 1,
  });

  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  SliverGridDelegateWithFixedCrossAxisCount toGridDelegate() {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
      childAspectRatio: childAspectRatio,
    );
  }
}
