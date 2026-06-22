import 'package:base_flutter_proj/auth/base_auth_form_page.dart';
import 'package:base_flutter_proj/auth/providers/auth_form_providers.dart';
import 'package:base_flutter_proj/auth/route/auth_route.dart';
import 'package:base_flutter_proj/auth/view/privacy_policy_widget.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/helpers/form_validator.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthByPhoneFormPage extends ConsumerStatefulWidget {
  const AuthByPhoneFormPage({super.key});

  @override
  ConsumerState<AuthByPhoneFormPage> createState() =>
      _AuthByPhoneFormPageState();
}

class _AuthByPhoneFormPageState extends ConsumerState<AuthByPhoneFormPage> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final isSubmitting = ref.watch(
      authByPhoneFormProvider.select((state) => state.isSubmitting),
    );
    final notifier = ref.read(authByPhoneFormProvider.notifier);

    return BaseAuthFormPage(
      appBarConfig: const AppPageAppBarConfig(needBuildAppBar: false),
      startInfo: Text(
        l10n.authPhoneTitle,
        style: AppTextStyle.body,
        textAlign: TextAlign.center,
      ),
      fieldController: _phoneController,
      fieldLabel: l10n.phoneLabel,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d+()\-\s]')),
      ],
      validator: (value) => FormValidator.validatePhone(
        value,
        emptyError: l10n.enterPhone,
        invalidError: l10n.phoneInvalid,
      ),
      onChanged: notifier.updatePhone,
      onContinue: _onContinuePressed,
      isSubmitting: isSubmitting,
      bottomWidget: PrivacyPolicyWidget(nextButtonText: l10n.continueButton),
    );
  }

  Future<void> _onContinuePressed(String phone) async {
    final notifier = ref.read(authByPhoneFormProvider.notifier);
    notifier.updatePhone(phone);
    await notifier.submitPhone();
    if (!mounted) return;
    PhoneConfirmationFormRoute(
      phoneNumber: notifier.model.phoneNumber,
    ).go(context);
  }
}
