import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит актуальный экземпляр [S], обновляемый из дерева локализаций.
class CurrentLocalizationsNotifier extends Notifier<S?> {
  Locale? _locale;

  @override
  S? build() => null;

  void update(S value, {required Locale locale}) {
    if (_locale == locale && state != null) {
      return;
    }
    _locale = locale;
    state = value;
  }
}

final currentLocalizationsProvider =
    NotifierProvider<CurrentLocalizationsNotifier, S?>(
  CurrentLocalizationsNotifier.new,
);

/// Локализации для слоя без [BuildContext] (notifier'ы, сервисы).
final appLocalizationsProvider = Provider<S>((ref) {
  final value = ref.watch(currentLocalizationsProvider);
  if (value == null) {
    throw StateError('Localizations are not initialized yet.');
  }
  return value;
});

/// Пробрасывает [S.of] в [currentLocalizationsProvider] после кадра.
///
/// защита от дурака (меня) запрещает изменение state во время build.
class AppLocalizationsBridge extends ConsumerWidget {
  const AppLocalizationsBridge({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final locale = Localizations.localeOf(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(currentLocalizationsProvider.notifier)
          .update(l10n, locale: locale);
    });

    return child;
  }
}
