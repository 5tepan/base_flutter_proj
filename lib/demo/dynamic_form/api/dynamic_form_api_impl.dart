import 'package:base_flutter_proj/core/base/base_api/api_response_parser.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/core/network/public_api.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api.dart';

class DynamicFormApiImpl implements DynamicFormApi {
  DynamicFormApiImpl(this._api);

  final PublicApi _api;

  static const _formsPath = 'forms';

  @override
  Future<DynamicFormSchema> fetchSchema(String formId) async {
    final response = await _api.sendGetRequest('$_formsPath/$formId/schema');

    final parsed = ApiResponseParser.parseObjectFromResponse<DynamicFormSchema>(
      response,
      key: 'form_schema',
      fromJson: DynamicFormSchema.fromJson,
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
}
