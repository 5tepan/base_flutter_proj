import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/network/core_api.dart';
import 'package:base_flutter_proj/shop/api/shop_api.dart';
import 'package:base_flutter_proj/shop/model/product.dart';

class ShopApiImpl implements ShopApi {
  ShopApiImpl(this._api);

  final CoreApi _api;

  static const _productsPath = 'shop/products';
  static const _productPath = 'shop/products';

  @override
  Future<List<Product>> fetchProducts({
    required int page,
    required int pageSize,
  }) async {
    final response = await _api.sendGetRequest(
      _productsPath,
      params: {
        'page': page,
        'pageSize': pageSize,
      },
    );

    final parsed = ApiResponseParser.parseListFromResponse<Product>(
      response,
      key: 'products',
      fromJson: Product.fromApiJson,
      emptyErrorCode: AppErrorCode.dataNotFound,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? AppErrorCode.requestFailed,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }

  @override
  Future<Product> fetchProduct(String id) async {
    final response = await _api.sendGetRequest('$_productPath/$id');

    final parsed = ApiResponseParser.parseObjectFromResponse<Product>(
      response,
      key: 'product',
      fromJson: Product.fromApiJson,
      emptyErrorCode: AppErrorCode.dataNotFound,
    );

    if (parsed.isError || parsed.result == null) {
      throw AppException(
        parsed.errorCode ?? AppErrorCode.dataNotFound,
        serverMessage: parsed.serverMessage,
      );
    }

    return parsed.result!;
  }
}
