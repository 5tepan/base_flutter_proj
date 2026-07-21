/// Контроллер для динамической формы.
///
/// Сейчас он хранит только текущие значения полей.
/// В дальнейшем можно расширить на touched/dirty и т.п.
library dynamic_form_controller;

import 'package:base_flutter_proj/core/base/model/models/form_model.dart';

class DynamicFormController {
  DynamicFormController({
    Map<String, dynamic>? initialValues,
    this.onFieldChanged,
  }) : _backingFormModel = null {
    if (initialValues != null) {
      _values.addAll(initialValues);
    }
  }

  DynamicFormController.fromFormModel(
    FormModel model, {
    void Function(String name, dynamic value)? onFieldChanged,
  }) : _backingFormModel = model,
       onFieldChanged = onFieldChanged {
    _values.addAll(model.fields);
  }

  final FormModel? _backingFormModel;
  final void Function(String name, dynamic value)? onFieldChanged;
  final Map<String, dynamic> _values = {};

  Map<String, dynamic> get values => _values;

  T? getValue<T>(String name) => _values[name] as T?;

  void setValue(String name, dynamic value) {
    _values[name] = value;
    if (onFieldChanged != null) {
      onFieldChanged!(name, value);
      return;
    }
    _backingFormModel?.setField(name, value);
  }

  void syncFromFormModel() {
    if (_backingFormModel == null) return;
    _values
      ..clear()
      ..addAll(_backingFormModel.fields);
  }

  void clear() {
    _values.clear();
    _backingFormModel?.reset();
  }
}
