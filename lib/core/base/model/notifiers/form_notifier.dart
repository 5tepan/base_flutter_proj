import 'package:base_flutter_proj/core/base/model/models/form_model.dart';
import 'package:base_flutter_proj/core/base/model/states/form_state.dart';
import 'package:base_flutter_proj/core/errors/error_mapper.dart';
import 'package:base_flutter_proj/core/helpers/async_executor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class FormNotifier<T extends FormModel> extends Notifier<FormState> {
  final AsyncExecutor _executor = AsyncExecutor();

  T get model;

  @override
  FormState build() {
    ref.onDispose(_executor.invalidate);
    return const FormState();
  }

  void setField(String key, dynamic value) {
    model.setField(key, value);
    state = state.copyWith(fields: Map.from(model.fields));
  }

  Future<void> runSubmit(Future<void> Function(T model) onSubmit) async {
    if (state.isSubmitting) return;

    final generation = _executor.capture();
    state = state.copyWith(isSubmitting: true, clearError: true);

    try {
      await onSubmit(model);
      if (!_executor.isCurrentGeneration(generation)) return;
      state = state.copyWith(isSubmitting: false);
    } catch (error) {
      if (!_executor.isCurrentGeneration(generation)) return;
      final mapped = ErrorMapper.from(error);
      state = state.copyWith(
        isSubmitting: false,
        errorCode: mapped.code,
        serverMessage: mapped.serverMessage,
      );
      rethrow;
    }
  }

  void reset() {
    model.reset();
    state = state.copyWith(fields: {});
  }
}
