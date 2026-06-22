import 'package:base_flutter_proj/core/base/model/states/entity_state.dart';
import 'package:base_flutter_proj/core/components/app_loading_indicator.dart';
import 'package:base_flutter_proj/core/components/base_error_widget.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:flutter/material.dart';

/// Аналог EntityStateNotifierBuilder из Elementary.
class EntityStateBuilder<T> extends StatelessWidget {
  const EntityStateBuilder({
    required this.state,
    required this.dataBuilder,
    super.key,
    this.initial,
    this.loading,
    this.error,
    this.onRetry,
  });

  final EntityState<T> state;
  final Widget Function(T data) dataBuilder;
  final WidgetBuilder? initial;
  final WidgetBuilder? loading;
  final Widget Function(AppErrorCode code, String? serverMessage)? error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      EntityStateInitial() =>
        initial?.call(context) ??
            loading?.call(context) ??
            const Center(child: AppLoadingIndicator()),
      EntityStateLoading(:final previous) when previous != null =>
        dataBuilder(previous),
      EntityStateLoading() =>
        loading?.call(context) ??
            const Center(child: AppLoadingIndicator()),
      EntityStateError(:final code, :final serverMessage) =>
        error?.call(code, serverMessage) ??
            BaseErrorWidget.fromError(
              errorCode: code,
              serverMessage: serverMessage,
              onPressedButton: onRetry ?? () {},
            ),
      EntityStateData(:final data) => dataBuilder(data),
    };
  }
}
