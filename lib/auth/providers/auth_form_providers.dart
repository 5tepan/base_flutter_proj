import 'package:base_flutter_proj/auth/model/view_model/auth_by_phone_form_view_model.dart';
import 'package:base_flutter_proj/auth/model/view_model/phone_confirmation_form_view_model.dart';
import 'package:base_flutter_proj/core/base/model/states/form_state.dart';
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
