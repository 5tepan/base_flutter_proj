import 'package:base_flutter_proj/core/base/model/models/form_model.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';

/// Базовая модель для schema-driven формы, совместимая с `FormModel`.
class DynamicFormModel extends FormModel {
  DynamicFormModel({
    required this.schema,
    Map<String, dynamic>? initialFields,
  }) {
    for (final field in schema.fields) {
      if (field.initialValue != null) {
        setField(field.name, field.initialValue);
      }
    }

    if (initialFields != null) {
      fields.addAll(initialFields);
    }
  }

  final DynamicFormSchema schema;
}
