import 'package:base_flutter_proj/core/base/model/models/base_model.dart';

class FormModel extends BaseModel {
  final Map<String, dynamic> fields = {};

  void setField(String key, dynamic value) {
    fields[key] = value;
  }

  T? getField<T>(String key) {
    return fields[key] as T?;
  }

  void reset() {
    fields.clear();
    clearError();
  }
}
