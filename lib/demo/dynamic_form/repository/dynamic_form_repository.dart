import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api.dart';

class DynamicFormRepository {
  DynamicFormRepository(this._api);

  final DynamicFormApi _api;

  Future<DynamicFormSchema> fetchSchema(String formId) {
    return _api.fetchSchema(formId);
  }
}
