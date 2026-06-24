import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_auth/smart_auth.dart';

/// SMS User Consent API (Android) для автоподстановки кода.
class SmsAutofillService {
  SmsAutofillService({SmartAuth? smartAuth})
      : _smartAuth = smartAuth ?? SmartAuth.instance;

  final SmartAuth _smartAuth;

  Future<String?> listenForCode({
    String matcher = r'\d{4,8}',
    String? senderPhoneNumber,
  }) async {
    if (!AppPlatform.isAndroid) {
      return null;
    }

    try {
      final result = await _smartAuth.getSmsWithUserConsentApi(
        matcher: matcher,
        senderPhoneNumber: senderPhoneNumber,
      );

      if (!result.hasData) {
        return null;
      }

      return result.data?.code;
    } catch (error, stackTrace) {
      debugPrint('SMS autofill failed: $error');
      debugPrint('$stackTrace');
      return null;
    }
  }

  Future<void> dispose() async {
    if (!AppPlatform.isAndroid) {
      return;
    }

    await _smartAuth.removeUserConsentApiListener();
    await _smartAuth.removeSmsRetrieverApiListener();
  }
}
