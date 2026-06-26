import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

/// Значения отступов контента экрана.
///
/// Применяются через [AppPageBodyConfig.padding] на [AppPageScaffold].
/// Единственное место настройки inset'ов для любого экрана.
abstract final class ScreenContentInsets {
  /// Отступы по умолчанию для всех экранов на [AppPageScaffold].
  static const EdgeInsets defaultInsets = horizontal;

  /// Без отступов (full-bleed: WebView, карта, edge-to-edge фон).
  static const EdgeInsets zero = EdgeInsets.zero;

  /// Горизонтальные отступы проекта.
  static const EdgeInsets horizontal = EdgeInsets.symmetric(
    horizontal: ThemeBuilder.defaultPadding,
  );

  /// Отступы со всех сторон.
  static const EdgeInsets all = EdgeInsets.all(ThemeBuilder.defaultPadding);
}
