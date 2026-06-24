import 'package:base_flutter_proj/core/base/model/states/entity_state.dart';
import 'package:base_flutter_proj/core/errors/error_mapper.dart';
import 'package:base_flutter_proj/core/helpers/async_executor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Notifier для экрана одной сущности (деталка).
/// Наследуйте и реализуйте [loadItem] через Repository.
abstract class ItemNotifier<T> extends Notifier<EntityState<T>> {
  final AsyncExecutor _executor = AsyncExecutor();

  Future<T> loadItem();

  @override
  EntityState<T> build() {
    ref.onDispose(_executor.invalidate);
    Future.microtask(load);
    return const EntityStateInitial();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    final generation = _executor.capture();
    final previous = state.dataOrNull;
    state = EntityStateLoading(previous: previous);

    try {
      final item = await loadItem();
      if (!_executor.isCurrentGeneration(generation)) return;
      state = EntityStateData(item);
    } catch (error) {
      if (!_executor.isCurrentGeneration(generation)) return;
      final mapped = ErrorMapper.from(error);
      state = EntityStateError(
        code: mapped.code,
        serverMessage: mapped.serverMessage,
        previous: previous,
      );
    }
  }

  Future<void> reload() => load();
}
