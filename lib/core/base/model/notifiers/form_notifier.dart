import 'package:base_flutter_proj/core/base/model/models/form_model.dart';
import 'package:base_flutter_proj/core/base/model/states/form_state.dart';
import 'package:flutter_riverpod/legacy.dart';

class FormNotifier extends StateNotifier<FormState> {
  final FormModel model;
  FormNotifier(this.model) : super(const FormState());

  void setField(String key, dynamic value) {
    model.setField(key, value);
    state = state.copyWith(fields: Map.from(model.fields));
  }

  void submit(Future<void> Function(FormModel) onSubmit) async {
    state = state.copyWith(isSubmitting: true, error: null);
    try {
      await onSubmit(model);
      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, error: e.toString());
    }
  }

  void reset() {
    model.reset();
    state = state.copyWith(fields: {});
  }
}
