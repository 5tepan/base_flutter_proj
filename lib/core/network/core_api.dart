import 'package:base_flutter_proj/core/base/base_api/base_api.dart';

/// Базовый HTTP-клиент для feature API, наследующих [BaseApi].
class CoreApi extends BaseApi {
  CoreApi({
    required super.config,
    required super.packageInfo,
    required super.checkConnection,
    super.tokenHolder,
    super.onRefreshToken,
  });
}
