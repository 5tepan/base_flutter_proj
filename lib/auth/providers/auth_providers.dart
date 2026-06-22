import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/api/auth_api_impl.dart';
import 'package:base_flutter_proj/auth/api/mock_auth_api.dart';
import 'package:base_flutter_proj/auth/model/auth_session.dart';
import 'package:base_flutter_proj/auth/repository/auth_repository.dart';
import 'package:base_flutter_proj/auth/storage/auth_session_storage.dart';
import 'package:base_flutter_proj/auth/token/auth_token_holder.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
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

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final config = ref.watch(configProvider);
  final tokenHolder = ref.watch(authTokenHolderProvider);
  final storage = ref.watch(authSessionStorageProvider);

  late AuthRepository repository;
  final AuthApi api;

  if (config.useMockAuthApi) {
    api = MockAuthApi();
  } else {
    api = AuthApiImpl(
      config: config,
      packageInfo: ref.watch(packageInfoProvider),
      checkConnection: () => ref.read(connectivityCheckProvider),
      tokenHolder: tokenHolder,
      onRefreshToken: () => repository.refreshTokens(),
    );
  }

  repository = AuthRepository(
    api: api,
    storage: storage,
    tokenHolder: tokenHolder,
  );
  return repository;
});

class AuthSessionNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    return ref.read(authRepositoryProvider).loadSession();
  }

  Future<void> signIn(AuthSession session) async {
    final saved = await ref.read(authRepositoryProvider).saveSession(session);
    state = AsyncData(saved);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  bool get isAuthenticated => state.value != null;
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthSession?>(
  AuthSessionNotifier.new,
);
