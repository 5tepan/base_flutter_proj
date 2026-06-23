import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeBuilderProvider = Provider<ThemeBuilder>((ref) {
  return ThemeBuilder();
});
