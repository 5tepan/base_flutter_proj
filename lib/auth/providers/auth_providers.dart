import 'package:base_flutter_proj/auth/api/auth_api.dart';
import 'package:base_flutter_proj/auth/api/auth_api_impl.dart';
import 'package:base_flutter_proj/auth/model/token_refresh_result.dart';
import 'package:base_flutter_proj/auth/repository/auth_repository.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/base/base_auth/providers/auth_infra_providers.dart';
import 'package:base_flutter_proj/core/providers/public_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApiImpl(ref.watch(publicApiProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    api: ref.watch(authApiProvider),
    storage: ref.watch(authSessionStorageProvider),
    tokenHolder: ref.watch(authTokenHolderProvider),
  );
});

class AuthSessionNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final repository = ref.read(authRepositoryProvider);
    final session = await repository.loadSession();
    if (session == null || !session.isExpired) {
      return session;
    }

    final refreshed = await repository.refreshTokens();
    return switch (refreshed) {
      TokenRefreshSuccess(:final session) => session,
      TokenRefreshRejected() => null,
      TokenRefreshUnavailable() => session,
    };
  }

  Future<void> signIn(AuthSession session) async {
    final saved = await ref.read(authRepositoryProvider).saveSession(session);
    state = AsyncData(saved);
  }

  Future<void> signOut() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncData(null);
  }

  /// Обновляет сессию для роутера и WebSocket. `false` — запрос не обновлён.
  Future<bool> refreshSession() async {
    final result = await ref.read(authRepositoryProvider).refreshTokens();
    switch (result) {
      case TokenRefreshSuccess(:final session):
        state = AsyncData(session);
        return true;
      case TokenRefreshRejected():
        state = const AsyncData(null);
        return false;
      case TokenRefreshUnavailable():
        return false;
    }
  }

  bool get isAuthenticated => state.value != null;
}

final authSessionProvider =
    AsyncNotifierProvider<AuthSessionNotifier, AuthSession?>(
  AuthSessionNotifier.new,
);
