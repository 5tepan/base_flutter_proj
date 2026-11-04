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
