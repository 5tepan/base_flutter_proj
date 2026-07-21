import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_notifier.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';

const dynamicFormDemoSchema = DynamicFormSchema(
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

final dynamicFormDemoProvider =
    dynamicFormProvider(dynamicFormDemoSchema);
