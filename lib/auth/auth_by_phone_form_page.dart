import 'package:base_flutter_proj/auth/base_auth_form_page.dart';
import 'package:base_flutter_proj/auth/model/data_model/auth_by_phone_form_data_model.dart';
import 'package:base_flutter_proj/auth/model/view_model/auth_by_phone_form_view_model.dart';
import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/auth/view/privacy_policy_widget.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/helpers/form_validator.dart';
import 'package:base_flutter_proj/core/helpers/mixins/loading_notifier_mixin.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthByPhoneFormPage extends StatefulWidget {
  const AuthByPhoneFormPage({super.key});

  @override
  State<AuthByPhoneFormPage> createState() => _AuthByPhoneFormPageState();
}

class _AuthByPhoneFormPageState extends State<AuthByPhoneFormPage>
    with LoadingNotifierMixin {
  final TextEditingController _phoneController = TextEditingController();
  final AuthByPhoneFormModel _model = AuthByPhoneFormModel(
    AuthByPhoneDataModel(),
  );
  late final AuthByPhoneFormNotifier _notifier = AuthByPhoneFormNotifier(
    _model,
  );
  @override
  void initState() {
    super.initState();
    bindLoading(
      notifier: _notifier,
      selectIsLoading: (state) => state.isSubmitting,
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseAuthFormPage(
      appBarConfig: const AppPageAppBarConfig(needBuildAppBar: false),
      startInfo: Text(
        'Введите номер телефона,\nчтобы получить код подтверждения',
        style: AppTextStyle.body,
        textAlign: TextAlign.center,
      ),
      fieldController: _phoneController,
      fieldLabel: 'Телефон',
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d+()\-\s]')),
      ],
      validator: FormValidator.validatePhone,
      onChanged: (value) => _notifier.updatePhone(value),
      onContinue: _onContinuePressed,
      isSubmitting: isScreenLoading,
      bottomWidget: const PrivacyPolicyWidget(nextButtonText: 'Продолжить'),
    );
  }

  Future<void> _onContinuePressed(String phone) async {
    _notifier.updatePhone(phone);
    await _notifier.submitPhone();
    if (!mounted) return;
    PhoneConfirmationFormRoute(phoneNumber: _model.phoneNumber).go(context);
  }
}
