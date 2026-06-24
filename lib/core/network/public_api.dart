import 'package:base_flutter_proj/core/base/base_api/base_api.dart';

/// HTTP-клиент для публичных эндпоинтов без Authorization и refresh token.
class PublicApi extends BaseApi {
  PublicApi({
    required super.config,
    required super.packageInfo,
    required super.checkConnection,
  }) : super();
}
