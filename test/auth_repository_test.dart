import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/model/token_refresh_result.dart';
import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/auth/repository/auth_repository.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_auth/storage/auth_session_storage.dart';
import 'package:base_flutter_proj/core/base/base_auth/token/auth_token_holder.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late _MemorySessionStorage storage;
  late AuthTokenHolder holder;
  late _FakeAuthApi api;
  late AuthRepository repository;

  AuthSession session({
    String access = 'access',
    String refresh = 'refresh',
    DateTime? expiresAt,
  }) {
    return AuthSession(
      accessToken: access,
      refreshToken: refresh,
      phoneNumber: '+79990000000',
      expiresAt: expiresAt,
    );
  }

  setUp(() {
    storage = _MemorySessionStorage();
    holder = AuthTokenHolder();
    api = _FakeAuthApi();
    repository = AuthRepository(
      api: api,
      storage: storage,
      tokenHolder: holder,
    );
  });

  test('refresh stores the new session', () async {
    storage.session = session();
    holder.update(storage.session);
    api.refreshResult = session(access: 'next', refresh: 'next-refresh');

    final result = await repository.refreshTokens();

    expect(result, isA<TokenRefreshSuccess>());
    expect(holder.accessToken, 'next');
    expect(storage.session?.refreshToken, 'next-refresh');
  });

  test('a network error keeps the saved session', () async {
    storage.session = session();
    holder.update(storage.session);
    api.refreshError = const AppException(AppErrorCode.connectionError);

    final result = await repository.refreshTokens();

    expect(result, isA<TokenRefreshUnavailable>());
    expect(storage.session?.accessToken, 'access');
    expect(holder.accessToken, 'access');
  });

  test('a rejected refresh signs the user out', () async {
    storage.session = session();
    holder.update(storage.session);
    api.refreshError = const AppException(AppErrorCode.refreshSessionFailed);

    final result = await repository.refreshTokens();

    expect(result, isA<TokenRefreshRejected>());
    expect(storage.session, isNull);
    expect(holder.accessToken, isNull);
  });

  test('parallel refreshes share one request', () async {
    storage.session = session();
    holder.update(storage.session);
    api.refreshDelay = const Duration(milliseconds: 40);
    api.refreshResult = session(access: 'shared');

    final results = await Future.wait([
      repository.refreshTokens(),
      repository.refreshTokens(),
    ]);

    expect(api.refreshCalls, 1);
    expect(results, everyElement(isA<TokenRefreshSuccess>()));
    expect(holder.accessToken, 'shared');
  });

  test('notifier replaces an expired session on startup', () async {
    storage.session = session(
      expiresAt: DateTime.now().subtract(const Duration(minutes: 5)),
    );
    api.refreshResult = session(access: 'fresh');

    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWith((ref) => repository)],
    );
    addTearDown(container.dispose);

    final loaded = await container.read(authSessionProvider.future);

    expect(loaded?.accessToken, 'fresh');
    expect(container.read(authSessionProvider).value?.accessToken, 'fresh');
  });

  test('notifier drops the session when refresh is rejected', () async {
    storage.session = session();
    holder.update(storage.session);
    api.refreshError = const AppException(AppErrorCode.refreshSessionFailed);
    final container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWith((ref) => repository)],
    );
    addTearDown(container.dispose);
    await container.read(authSessionProvider.future);

    final refreshed = await container
        .read(authSessionProvider.notifier)
        .refreshSession();

    expect(refreshed, isFalse);
    expect(container.read(authSessionProvider).value, isNull);
  });
}

class _MemorySessionStorage extends AuthSessionStorage {
  _MemorySessionStorage() : super(const FlutterSecureStorage());

  AuthSession? session;

  @override
  Future<AuthSession?> read() async => session;

  @override
  Future<void> save(AuthSession value) async {
    session = value;
  }

  @override
  Future<void> clear() async {
    session = null;
  }
}

class _FakeAuthApi implements AuthApi {
  AuthSession? refreshResult;
  AppException? refreshError;
  Duration refreshDelay = Duration.zero;
  int refreshCalls = 0;

  @override
  Future<void> requestConfirmationCode(String phoneNumber) async {}

  @override
  Future<void> resendCode(String phoneNumber) async {}

  @override
  Future<AuthSession> verifyCode({
    required String phoneNumber,
    required String confirmationCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<AuthSession> refreshToken(String refreshToken) async {
    refreshCalls++;
    if (refreshDelay > Duration.zero) {
      await Future<void>.delayed(refreshDelay);
    }
    final error = refreshError;
    if (error != null) {
      throw error;
    }
    return refreshResult!;
  }
}
