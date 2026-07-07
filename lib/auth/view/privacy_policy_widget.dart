import 'package:base_flutter_proj/core/components/gestures/on_tap_gesture_recognizer.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:base_flutter_proj/web_view/route/web_view_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrivacyPolicyWidget extends ConsumerWidget {
  const PrivacyPolicyWidget({
    this.onReturnFromDocument,
    this.nextButtonText = 'Авторизоваться',
    super.key,
  });

  final String nextButtonText;
  final VoidCallback? onReturnFromDocument;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = S.of(context);
    final pages = ref.watch(appSettingsProvider).pages;
    final defaultStyle = AppTextStyle.body.copyWith(color: AppColors.darkGrey);

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: l10n.privacyAgreementPrefix(nextButtonText)),
          TextSpan(
            text: l10n.privacyPolicy,
            style: AppTextStyle.body.copyWith(color: AppColors.secondaryColor),
            recognizer: pages?.privacyPolicy == null
                ? null
                : OnTapGestureRecognizer(() async {
                    await _onPolicyPressed(context, pages!.privacyPolicy!);
                    onReturnFromDocument?.call();
                  }),
          ),
          TextSpan(text: l10n.privacyAgreementAnd),
          TextSpan(
            text: l10n.termsOfUse,
            style: AppTextStyle.body.copyWith(color: AppColors.secondaryColor),
            recognizer: pages?.termsOfUse == null
                ? null
                : OnTapGestureRecognizer(() async {
                    await _onTermsOfUsePressed(context, pages!.termsOfUse!);
                    onReturnFromDocument?.call();
                  }),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: defaultStyle,
    );
  }

  Future<void> _onTermsOfUsePressed(BuildContext context, String url) async {
    final l10n = S.of(context);
    await WebViewRoute(
      url: url,
      title: l10n.termsOfUseTitle,
    ).push(context);
  }

  Future<void> _onPolicyPressed(BuildContext context, String url) async {
    final l10n = S.of(context);
    await WebViewRoute(
      url: url,
      title: l10n.privacyPolicyTitle,
    ).push(context);
  }
}
