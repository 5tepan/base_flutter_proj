import 'package:base_flutter_proj/auth/model/data_model/phone_confirmation_form_data_model.dart';
import 'package:base_flutter_proj/core/base/model/models/form_model.dart';
import 'package:base_flutter_proj/core/base/model/notifiers/form_notifier.dart';

class PhoneConfirmationFormModel extends FormModel {
  static const String codeField = 'confirmation_code';

  PhoneConfirmationFormModel({
    required this.phoneNumber,
    required this.dataModel,
  });

  final String phoneNumber;
  final PhoneConfirmationDataModel dataModel;

  String get confirmationCode => getField<String>(codeField) ?? '';

  set confirmationCode(String value) => setField(codeField, value);
}

class PhoneConfirmationFormNotifier
    extends FormNotifier<PhoneConfirmationFormModel> {
  PhoneConfirmationFormNotifier(super.model);

  void updateCode(String value) {
    setField(PhoneConfirmationFormModel.codeField, value);
  }

  Future<void> submitConfirmation() async {
    await runSubmit((model) {
      return model.dataModel.verifyCode(
        phone: model.phoneNumber,
        confirmationCode: model.confirmationCode,
      );
    });
  }

  Future<void> resendCode() async {
    await runSubmit((model) {
      return model.dataModel.resendCode(phone: model.phoneNumber);
    });
  }
}
