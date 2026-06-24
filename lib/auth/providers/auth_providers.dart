import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/api/auth_api_impl.dart';
import 'package:base_flutter_proj/auth/api/mock_auth_api.dart';
import 'package:base_flutter_proj/auth/repository/auth_repository.dart';
import 'package:base_flutter_proj/core/base/base_auth/model/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_auth/providers/auth_infra_providers.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
