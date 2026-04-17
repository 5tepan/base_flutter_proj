import 'package:base_flutter_proj/auth/model/data_model/auth_by_phone_form_data_model.dart';
import 'package:base_flutter_proj/core/base/model/models/form_model.dart';
import 'package:base_flutter_proj/core/base/model/notifiers/form_notifier.dart';

class AuthByPhoneFormModel extends FormModel {
  static const String phoneField = 'phone_number';

  AuthByPhoneFormModel(this.dataModel);

  final AuthByPhoneDataModel dataModel;

  String get phoneNumber => getField<String>(phoneField) ?? '';

  set phoneNumber(String value) => setField(phoneField, value);
}

class AuthByPhoneFormNotifier extends FormNotifier<AuthByPhoneFormModel> {
  AuthByPhoneFormNotifier(super.model);

  void updatePhone(String value) {
    setField(AuthByPhoneFormModel.phoneField, value);
  }

  Future<void> submitPhone() async {
    await runSubmit((model) async {
      await model.dataModel.requestConfirmationCode(model.phoneNumber);
    });
  }
}
