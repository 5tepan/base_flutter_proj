import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/core/base/base_auth/providers/auth_infra_providers.dart';
import 'package:base_flutter_proj/core/network/core_api.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Публичный API-клиент: без Authorization и refresh token.
/// Для login, регистрации, справочников и других guest-эндпоинтов.
final publicApiProvider = Provider<PublicApi>((ref) {
  return PublicApi(
    config: ref.watch(configProvider),
    packageInfo: ref.watch(packageInfoProvider),
    checkConnection: () => ref.read(connectivityCheckProvider),
  );
});

/// API-клиент с авторизацией и refresh token.
/// Feature API наследуют [CoreApi] или создают свой провайдер по этому образцу.
final coreApiProvider = Provider<CoreApi>((ref) {
  return CoreApi(
    config: ref.watch(configProvider),
    packageInfo: ref.watch(packageInfoProvider),
    checkConnection: () => ref.read(connectivityCheckProvider),
    tokenHolder: ref.watch(authTokenHolderProvider),
    onRefreshToken: () => ref.read(authRepositoryProvider).refreshTokens(),
  );
});
