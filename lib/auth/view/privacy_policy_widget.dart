import 'package:base_flutter_proj/core/components/gestures/on_tap_gesture_recognizer.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/web_view/route/web_view_route.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  static const String _privacyPolicyUrl = 'https://cat-bounce.com/';
  static const String _termsOfUseUrl = 'https://cat-bounce.com/';

  final String nextButtonText;
  final VoidCallback? onReturnFromDocument;

  const PrivacyPolicyWidget({
    this.onReturnFromDocument,
    this.nextButtonText = 'Авторизоваться',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = AppTextStyle.body.copyWith(color: AppColors.darkGrey);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Нажимая на кнопку «$nextButtonText», Вы\n соглашаетесь с ',
          ),
          TextSpan(
            text: 'Политикой конфиденциальности',
            style: AppTextStyle.body.copyWith(color: AppColors.secondaryColor),
            recognizer: OnTapGestureRecognizer(() async {
              await _onPolicyPressed(context);
              onReturnFromDocument?.call();
            }),
          ),
          const TextSpan(text: '\nи c '),
          TextSpan(
            text: 'Условиями использования',
            style: AppTextStyle.body.copyWith(color: AppColors.secondaryColor),
            recognizer: OnTapGestureRecognizer(() async {
              await _onTermsOfUsePressed(context);
              onReturnFromDocument?.call();
            }),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: defaultStyle,
    );
  }

  Future<void> _onTermsOfUsePressed(BuildContext context) async {
    await WebViewRoute(
      url: _termsOfUseUrl,
      title: 'Условия использования',
    ).push(context);
  }

  Future<void> _onPolicyPressed(BuildContext context) async {
    await WebViewRoute(
      url: _privacyPolicyUrl,
      title: 'Политика конфиденциальности',
    ).push(context);
  }
}
