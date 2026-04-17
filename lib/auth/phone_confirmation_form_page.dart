import 'dart:async';

import 'package:base_flutter_proj/auth/base_auth_form_page.dart';
import 'package:base_flutter_proj/auth/model/data_model/phone_confirmation_form_data_model.dart';
import 'package:base_flutter_proj/auth/model/view_model/phone_confirmation_form_view_model.dart';
import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/helpers/form_validator.dart';
import 'package:base_flutter_proj/core/helpers/mixins/loading_notifier_mixin.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/home/home_route.dart';
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
    extends ConsumerState<PhoneConfirmationFormPage>
    with LoadingNotifierMixin {
  static const int _initialTimerSeconds = 60;

  final TextEditingController _codeController = TextEditingController();
  late final PhoneConfirmationFormModel _model = PhoneConfirmationFormModel(
    phoneNumber: widget.phoneNumber,
    dataModel: PhoneConfirmationDataModel(),
  );
  late final PhoneConfirmationFormNotifier _notifier =
      PhoneConfirmationFormNotifier(_model);
  Timer? _timer;
  int _secondsLeft = _initialTimerSeconds;

  @override
  void initState() {
    super.initState();
    bindLoading(
      notifier: _notifier,
      selectIsLoading: (state) => state.isSubmitting,
    );
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseAuthFormPage(
      appBarConfig: const AppPageAppBarConfig(needBuildAppBar: false),
      startInfo: _buildStartInfo(),
      fieldController: _codeController,
      fieldLabel: 'Код подтверждения',
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: FormValidator.validateCode,
      onChanged: (value) => _notifier.updateCode(value),
      onContinue: _onContinuePressed,
      isSubmitting: isScreenLoading,
      bottomWidget: _buildBottomWidget(context),
      buttonText: 'Продолжить',
    );
  }

  Widget _buildStartInfo() {
    const baseStyle = AppTextStyle.body;
    return Text.rich(
      TextSpan(
        style: baseStyle,
        children: [
          TextSpan(text: 'На телефон '),
          TextSpan(
            text: widget.phoneNumber,
            style: baseStyle.copyWith(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: ' отправлено\nСМС с кодом подтверждения'),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildBottomWidget(BuildContext context) {
    if (_secondsLeft > 0) {
      return Text(
        'Повторная отправка через ${_formatDuration(_secondsLeft)}',
        style: AppTextStyle.body.copyWith(color: AppColors.darkGrey),
      );
    }

    return TextButton(
      onPressed: _onResendPressed,
      child: const Text('Отправить код повторно'),
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
    await _notifier.resendCode();
    if (!mounted) return;
    setState(_startTimer);
  }

  Future<void> _onContinuePressed(String code) async {
    _notifier.updateCode(code);
    await _notifier.submitConfirmation();
    if (!mounted) return;
    ref.read(authStatusProvider.notifier).setAuthorized(true);
    const HomeRoute().go(context);
  }
}
