import 'package:base_flutter_proj/core/base/model/models/form_model.dart';
import 'package:base_flutter_proj/core/base/model/states/form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class FormNotifier<T extends FormModel> extends Notifier<FormState> {
  T get model;

  @override
  FormState build() => const FormState();

  void setField(String key, dynamic value) {
    model.setField(key, value);
    state = state.copyWith(fields: Map.from(model.fields));
  }

  Future<void> runSubmit(Future<void> Function(T model) onSubmit) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await onSubmit(model);
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
      rethrow;
    }
  }

  void reset() {
    model.reset();
    state = state.copyWith(fields: {});
  }
}
