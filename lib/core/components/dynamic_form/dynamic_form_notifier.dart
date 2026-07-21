import 'package:base_flutter_proj/core/base/model/notifiers/form_notifier.dart';
import 'package:base_flutter_proj/core/base/model/states/form_state.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_controller.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_model.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dynamicFormProvider = NotifierProvider.autoDispose.family<
    DynamicFormNotifier,
    FormState,
    DynamicFormSchema>(
  DynamicFormNotifier.new,
);

/// `FormNotifier` для schema-driven форм.
///
/// Значения полей синхронизируются с [DynamicFormController] через [setField].
class DynamicFormNotifier extends FormNotifier<DynamicFormModel> {
  DynamicFormNotifier(this._schema);

  final DynamicFormSchema _schema;
  late DynamicFormModel _model;
  late DynamicFormController _controller;

  @override
  DynamicFormModel get model => _model;

  DynamicFormController get controller => _controller;

  @override
  FormState build() {
    _model = DynamicFormModel(schema: _schema);
    _controller = DynamicFormController.fromFormModel(
      model,
      onFieldChanged: setField,
    );
    return super.build().copyWith(fields: Map.from(model.fields));
  }

  @override
  void reset() {
    super.reset();
    _controller.syncFromFormModel();
  }

  Future<void> submit(Future<void> Function(DynamicFormModel model) action) {
    return runSubmit(action);
  }
}
