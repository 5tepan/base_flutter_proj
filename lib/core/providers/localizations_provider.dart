import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Хранит актуальный экземпляр [S], обновляемый из [MaterialApp.builder].
class CurrentLocalizationsNotifier extends Notifier<S?> {
  @override
  S? build() => null;

  void update(S value) => state = value;
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
