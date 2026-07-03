import 'dart:async';

import 'package:base_flutter_proj/auth/base_auth_form_page.dart';
import 'package:base_flutter_proj/auth/providers/auth_form_providers.dart';
import 'package:base_flutter_proj/core/base/base_auth/providers/auth_infra_providers.dart';
import 'package:base_flutter_proj/core/base/base_auth/services/sms_autofill_service.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/helpers/form_validator.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/home/route/home_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneConfirmationFormPage extends ConsumerStatefulWidget {
  const PhoneConfirmationFormPage({required this.phoneNumber, super.key});

  final String phoneNumber;

  @override
  ConsumerState<PhoneConfirmationFormPage> createState() =>
      _PhoneConfirmationFormPageState();
}

class _PhoneConfirmationFormPageState
    extends ConsumerState<PhoneConfirmationFormPage> {
  static const int _initialTimerSeconds = 60;

  final TextEditingController _codeController = TextEditingController();
  Timer? _timer;
  int _secondsLeft = _initialTimerSeconds;
  late final SmsAutofillService _smsAutofill;

  @override
  void initState() {
    super.initState();
    _smsAutofill = ref.read(smsAutofillServiceProvider);
    _startTimer();
    _listenForSmsCode();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _smsAutofill.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _listenForSmsCode() async {
    final code = await _smsAutofill.listenForCode();
    if (!mounted || code == null || code.isEmpty) {
      return;
    }

    _codeController.text = code;
    ref
        .read(phoneConfirmationFormProvider(widget.phoneNumber).notifier)
        .updateCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final formProvider = phoneConfirmationFormProvider(widget.phoneNumber);
    final isSubmitting = ref.watch(
      formProvider.select((state) => state.isSubmitting),
    );
    final notifier = ref.read(formProvider.notifier);

    return BaseAuthFormPage(
      appBarConfig: const AppPageAppBarConfig(needBuildAppBar: false),
      startInfo: Text(
        l10n.codeSentToPhone(widget.phoneNumber),
        style: AppTextStyle.body,
        textAlign: TextAlign.center,
      ),
      fieldController: _codeController,
      fieldLabel: l10n.confirmationCodeLabel,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) => FormValidator.validateCode(
        value,
        l10n: l10n,
        error: l10n.enterCode,
      ),
      onChanged: notifier.updateCode,
      onContinue: _onContinuePressed,
      isSubmitting: isSubmitting,
      bottomWidget: _buildBottomWidget(context),
      buttonText: l10n.continueButton,
    );
  }

  Widget _buildBottomWidget(BuildContext context) {
    final l10n = S.of(context);
    if (_secondsLeft > 0) {
      return Text(
        l10n.resendCodeIn(_formatDuration(_secondsLeft)),
        style: AppTextStyle.body.copyWith(color: AppColors.darkGrey),
      );
    }

    return TextButton(
      onPressed: _onResendPressed,
      child: Text(l10n.resendCodeButton),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  void _startTimer() {
    _timer?.cancel();
    _secondsLeft = _initialTimerSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
        return;
      }
      setState(() => _secondsLeft -= 1);
    });
  }

  Future<void> _onResendPressed() async {
    final notifier = ref.read(
      phoneConfirmationFormProvider(widget.phoneNumber).notifier,
    );
    await notifier.resendCode();
    if (!mounted) return;
    setState(_startTimer);
  }

  Future<void> _onContinuePressed(String code) async {
    final notifier = ref.read(
      phoneConfirmationFormProvider(widget.phoneNumber).notifier,
    );
    notifier.updateCode(code);
    final success = await notifier.submitConfirmation();
    if (!mounted || !success) return;
    const HomeRoute().go(context);
  }
}
