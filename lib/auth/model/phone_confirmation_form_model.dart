import 'package:base_flutter_proj/core/base/model/models/form_model.dart';

class PhoneConfirmationFormModel extends FormModel {
  static const String codeField = 'confirmation_code';

  PhoneConfirmationFormModel(this.phoneNumber);

  final String phoneNumber;

  String get confirmationCode => getField<String>(codeField) ?? '';

  set confirmationCode(String value) => setField(codeField, value);
}
