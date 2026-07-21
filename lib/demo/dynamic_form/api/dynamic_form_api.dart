import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';

abstract class DynamicFormApi {
  Future<DynamicFormSchema> fetchSchema(String formId);
}
