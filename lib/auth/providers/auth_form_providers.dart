import 'package:base_flutter_proj/auth/model/auth_by_phone_form_model.dart';
import 'package:base_flutter_proj/auth/model/phone_confirmation_form_model.dart';
import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/auth/repository/auth_repository.dart';
import 'package:base_flutter_proj/core/base/model/notifiers/form_notifier.dart';
import 'package:base_flutter_proj/core/base/model/states/form_state.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/l10n/error_localizer.dart';
import 'package:base_flutter_proj/core/providers/toast_service_provider.dart';
import 'package:base_flutter_proj/core/services/toast_service.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authByPhoneFormProvider =
    NotifierProvider<AuthByPhoneFormNotifier, FormState>(
  AuthByPhoneFormNotifier.new,
);

final phoneConfirmationFormProvider = NotifierProvider.family<
    PhoneConfirmationFormNotifier,
    FormState,
    String>(
  PhoneConfirmationFormNotifier.new,
);

class AuthByPhoneFormNotifier extends FormNotifier<AuthByPhoneFormModel> {
  final AuthByPhoneFormModel _model = AuthByPhoneFormModel();

  late AuthRepository _repository;
  late ToastService _toast;

  @override
  AuthByPhoneFormModel get model => _model;

  @override
  FormState build() {
    _repository = ref.read(authRepositoryProvider);
    _toast = ref.read(toastServiceProvider);
    return super.build();
  }

  void updatePhone(String value) {
    setField(AuthByPhoneFormModel.phoneField, value);
  }

  Future<void> submitPhone() async {
    try {
      await runSubmit((model) async {
        await _repository.requestConfirmationCode(model.phoneNumber);
      });
    } on AppException catch (error) {
      _toast.showError(ErrorLocalizer.fromAppException(error));
    } catch (error) {
      _toast.showError(S.current.authSendCodeError);
    }
  }
}

class PhoneConfirmationFormNotifier
    extends FormNotifier<PhoneConfirmationFormModel> {
  PhoneConfirmationFormNotifier(String phoneNumber)
      : _model = PhoneConfirmationFormModel(phoneNumber);

  final PhoneConfirmationFormModel _model;

  late AuthRepository _repository;
  late ToastService _toast;

  @override
  PhoneConfirmationFormModel get model => _model;

  @override
  FormState build() {
    _repository = ref.read(authRepositoryProvider);
    _toast = ref.read(toastServiceProvider);
    return super.build();
  }

  void updateCode(String value) {
    setField(PhoneConfirmationFormModel.codeField, value);
  }

  Future<bool> submitConfirmation() async {
    try {
      await runSubmit((model) async {
        final session = await _repository.verifyCode(
          phoneNumber: model.phoneNumber,
          confirmationCode: model.confirmationCode,
        );
        await ref.read(authSessionProvider.notifier).signIn(session);
      });
      return true;
    } on AppException catch (error) {
      _toast.showError(ErrorLocalizer.fromAppException(error));
      return false;
    } catch (error) {
      _toast.showError(S.current.authConfirmCodeError);
      return false;
    }
  }

  Future<void> resendCode() async {
    try {
      await runSubmit((model) async {
        await _repository.resendCode(model.phoneNumber);
      });
    } on AppException catch (error) {
      _toast.showError(ErrorLocalizer.fromAppException(error));
    } catch (error) {
      _toast.showError(S.current.authResendCodeError);
    }
  }
}
