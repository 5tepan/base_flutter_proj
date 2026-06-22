import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:flutter/foundation.dart';

/// Унифицированное состояние экрана: initial / loading / error / data.
sealed class EntityState<T> {
  const EntityState();
}

final class EntityStateInitial<T> extends EntityState<T> {
  const EntityStateInitial();
}

final class EntityStateLoading<T> extends EntityState<T> {
  const EntityStateLoading({this.previous});

  final T? previous;
}

final class EntityStateError<T> extends EntityState<T> {
  const EntityStateError({
    required this.code,
    this.serverMessage,
    this.previous,
  });

  final AppErrorCode code;
  final String? serverMessage;
  final T? previous;
}

final class EntityStateData<T> extends EntityState<T> {
  const EntityStateData(this.data);

  final T data;
}

extension EntityStateX<T> on EntityState<T> {
  bool get isInitial => this is EntityStateInitial<T>;
  bool get isLoading => this is EntityStateLoading<T>;
  bool get isError => this is EntityStateError<T>;
  bool get hasData => this is EntityStateData<T>;

  T? get dataOrNull => switch (this) {
        EntityStateData(:final data) => data,
        EntityStateLoading(:final previous) => previous,
        EntityStateError(:final previous) => previous,
        _ => null,
      };

  @visibleForTesting
  EntityStateError<T>? get errorOrNull =>
      this is EntityStateError<T> ? this as EntityStateError<T> : null;
}
