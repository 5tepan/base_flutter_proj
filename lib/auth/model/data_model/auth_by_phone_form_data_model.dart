import 'package:base_flutter_proj/core/base/model/models/base_data_model.dart';

class AuthByPhoneDataModel extends BaseDataModel<void> {
  String? lastRequestedPhone;

  @override
  Future<void> load() async {}

  Future<void> requestConfirmationCode(String phoneNumber) async {
    isLoading = true;
    clearError();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      lastRequestedPhone = phoneNumber;
    } catch (error) {
      setError(error);
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}