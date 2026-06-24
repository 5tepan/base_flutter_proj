import 'package:base_flutter_proj/core/base/base_auth/services/sms_autofill_service.dart';
import 'package:base_flutter_proj/core/base/base_auth/storage/auth_session_storage.dart';
import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authTokenHolderProvider = Provider<AuthTokenHolder>((ref) {
  return AuthTokenHolder();
});

final authSessionStorageProvider = Provider<AuthSessionStorage>((ref) {
  return const AuthSessionStorage(
    FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
});

final smsAutofillServiceProvider = Provider<SmsAutofillService>((ref) {
  return SmsAutofillService();
});
