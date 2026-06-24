import 'package:base_flutter_proj/core/base/model/models/form_model.dart';

class AuthByPhoneFormModel extends FormModel {
  static const String phoneField = 'phone_number';

  String get phoneNumber => getField<String>(phoneField) ?? '';

  set phoneNumber(String value) => setField(phoneField, value);
}
