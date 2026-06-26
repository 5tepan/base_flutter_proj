import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

typedef PaginatedSeparatorBuilder = Widget Function(
  BuildContext context,
  int index,
);

/// Настройки списка с пагинацией: только разделители между элементами.
///
/// Отступы экрана — только через [AppPageBodyConfig.padding] на [AppPageScaffold].
class PaginatedListLayout {
  const PaginatedListLayout({
    this.separatorBuilder,
    this.showSeparatorAfterLastItem = false,
  });

  final PaginatedSeparatorBuilder? separatorBuilder;
  final bool showSeparatorAfterLastItem;
}

/// Готовые разделители для [PaginatedListLayout.separatorBuilder].
abstract final class PaginatedSeparator {
  static Widget divider({
    double indent = 0,
    double endIndent = 0,
    Color? color,
    double height = 1,
    double thickness = 1,
  }) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color ?? AppColors.divider,
      indent: indent,
      endIndent: endIndent,
    );
  }
}
