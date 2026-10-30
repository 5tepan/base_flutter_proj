import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/auth_by_phone_form_page.dart';
import 'package:base_flutter_proj/auth/repository/auth_repository.dart';
import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_auth/storage/auth_session_storage.dart';
import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/model/entities/app_settings.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/providers/localizations_provider.dart';
import 'package:base_flutter_proj/core/providers/toast_service_provider.dart';
import 'package:base_flutter_proj/core/services/toast_service.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('stays on the phone form when sending the code fails', (
    tester,
  ) async {
    final api = _NavigationAuthApi()
      ..sendError = const AppException(AppErrorCode.sendCodeFailed);
    await _pumpPhoneForm(tester, api);

    await tester.enterText(find.byType(TextFormField), '9000000000');
    await tester.tap(find.text('Продолжить'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Продолжить'), findsOneWidget);
    expect(find.textContaining('code:'), findsNothing);
  });

  testWidgets('opens the code screen after the code is sent', (tester) async {
    final api = _NavigationAuthApi();
    await _pumpPhoneForm(tester, api);

    await tester.enterText(find.byType(TextFormField), '9000000000');
    await tester.tap(find.text('Продолжить'));
    await tester.pump();
    await tester.pump();

    expect(find.textContaining('code:'), findsOneWidget);
  });
}

Future<void> _pumpPhoneForm(WidgetTester tester, _NavigationAuthApi api) async {
  final repository = AuthRepository(
    api: api,
    storage: _MemorySessionStorage(),
    tokenHolder: AuthTokenHolder(),
  );
  final router = GoRouter(
    initialLocation: '/auth/phone',
    routes: [
      GoRoute(
        path: '/auth/phone',
        builder: (context, state) => const AuthByPhoneFormPage(),
      ),
      GoRoute(
        path: '/auth/confirm/:phoneNumber',
        builder: (context, state) =>
            Text('code:${state.pathParameters['phoneNumber']}'),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => repository),
        appSettingsProvider.overrideWithValue(AppSettings.defaults),
        toastServiceProvider.overrideWith((ref) => _SilentToast()),
      ],
      child: MaterialApp.router(
        locale: const Locale('ru'),
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        routerConfig: router,
        builder: (context, child) {
          return AppLocalizationsBridge(
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    ),
  );
  await tester.pump();
}

class _SilentToast extends ToastService {
  @override
  void showError(String? message) {}

  @override
  void showMessage(String? message) {}
}

class _MemorySessionStorage extends AuthSessionStorage {
  _MemorySessionStorage() : super(const FlutterSecureStorage());

  @override
  Future<AuthSession?> read() async => null;

  @override
  Future<void> save(AuthSession session) async {}

  @override
  Future<void> clear() async {}
}

class _NavigationAuthApi implements AuthApi {
  AppException? sendError;

  @override
  Future<void> requestConfirmationCode(String phoneNumber) async {
    final error = sendError;
    if (error != null) {
      throw error;
    }
  }

  @override
  Future<void> resendCode(String phoneNumber) async {}

  @override
  Future<AuthSession> refreshToken(String refreshToken) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  }) {
    throw UnimplementedError();
  }
}
