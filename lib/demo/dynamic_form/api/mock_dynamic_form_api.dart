import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api.dart';

/// Mock API для dev без бэкенда.
class MockDynamicFormApi implements DynamicFormApi {
  static const Duration _latency = Duration(milliseconds: 400);

  /// Идентификатор демо-формы в mock/real API.
  static const demoFormId = 'demo';

  /// Schema демо-формы — используется mock API и как локальный fallback.
  static const DynamicFormSchema demoSchema = DynamicFormSchema(
    version: 1,
    fields: [
      DynamicFormFieldSchema(
        name: 'full_name',
        label: 'Имя и фамилия',
        type: DynamicFormFieldType.text,
        required: true,
        minLength: 2,
        maxLength: 60,
      ),
      DynamicFormFieldSchema(
        name: 'email',
        label: 'Email',
        type: DynamicFormFieldType.email,
        required: true,
      ),
      DynamicFormFieldSchema(
        name: 'phone',
        label: 'Телефон',
        type: DynamicFormFieldType.phone,
      ),
      DynamicFormFieldSchema(
        name: 'age',
        label: 'Возраст',
        type: DynamicFormFieldType.number,
        required: true,
        min: 0,
        max: 120,
      ),
      DynamicFormFieldSchema(
        name: 'country',
        label: 'Страна',
        type: DynamicFormFieldType.select,
        required: true,
        options: [
          DynamicFormSelectOption(value: 'ru', label: 'Россия'),
          DynamicFormSelectOption(value: 'kz', label: 'Казахстан'),
          DynamicFormSelectOption(value: 'ua', label: 'Украина'),
        ],
      ),
      DynamicFormFieldSchema(
        name: 'bio',
        label: 'О себе',
        type: DynamicFormFieldType.textarea,
        maxLines: 5,
        maxLength: 400,
      ),
      DynamicFormFieldSchema(
        name: 'subscribe',
        label: 'Хочу получать уведомления',
        type: DynamicFormFieldType.checkbox,
        helperText: 'Можно будет изменить позже в настройках.',
      ),
    ],
  );

  @override
  Future<DynamicFormSchema> fetchSchema(String formId) async {
    await Future<void>.delayed(_latency);

    if (formId == demoFormId) {
      return demoSchema;
    }

    throw const AppException(AppErrorCode.dataNotFound);
  }
}
