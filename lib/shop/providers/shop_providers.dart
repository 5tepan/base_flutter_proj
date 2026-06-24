import 'package:base_flutter_proj/core/providers/api_providers.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/shop/api/mock_shop_api.dart';
import 'package:base_flutter_proj/shop/api/shop_api.dart';
import 'package:base_flutter_proj/shop/api/shop_api_impl.dart';
import 'package:base_flutter_proj/shop/repository/shop_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopApiProvider = Provider<ShopApi>((ref) {
  final config = ref.watch(configProvider);
  if (config.useMockShopApi) {
    return MockShopApi();
  }
  return ShopApiImpl(ref.watch(coreApiProvider));
});

final shopRepositoryProvider = Provider<ShopRepository>((ref) {
  return ShopRepository(ref.watch(shopApiProvider));
});
