import 'package:base_flutter_proj/core/base/base_api/base_api.dart';

/// HTTP-клиент для защищённых эндпоинтов с Authorization и refresh token.
class CoreApi extends BaseApi {
  CoreApi({
    required super.config,
    required super.packageInfo,
    required super.checkConnection,
    super.tokenHolder,
    super.onRefreshToken,
  });
}
