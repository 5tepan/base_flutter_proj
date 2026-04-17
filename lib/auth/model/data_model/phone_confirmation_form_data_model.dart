import 'package:base_flutter_proj/core/base/model/models/base_data_model.dart';

class PhoneConfirmationDataModel extends BaseDataModel<void> {
  String? lastConfirmedCode;
  String? phoneNumber;

  @override
  Future<void> load() async {}

  Future<void> verifyCode({
    required String phone,
    required String confirmationCode,
  }) async {
    isLoading = true;
    clearError();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 400));
      phoneNumber = phone;
      lastConfirmedCode = confirmationCode;
    } catch (error) {
      setError(error);
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  Future<void> resendCode({required String phone}) async {
    isLoading = true;
    clearError();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 350));
      phoneNumber = phone;
    } catch (error) {
      setError(error);
      rethrow;
    } finally {
      isLoading = false;
    }
  }
}
