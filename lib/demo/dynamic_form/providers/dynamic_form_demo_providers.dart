import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/core/providers/api_providers.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api_impl.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/mock_dynamic_form_api.dart';
import 'package:base_flutter_proj/demo/dynamic_form/repository/dynamic_form_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dynamicFormApiProvider = Provider<DynamicFormApi>((ref) {
  final config = ref.watch(configProvider);
  if (config.useMockDynamicFormApi) {
    return MockDynamicFormApi();
  }
  return DynamicFormApiImpl(ref.watch(publicApiProvider));
});

final dynamicFormRepositoryProvider = Provider<DynamicFormRepository>((ref) {
  return DynamicFormRepository(ref.watch(dynamicFormApiProvider));
});

/// Загрузка schema демо-формы с сервера (mock или real API).
final dynamicFormDemoSchemaProvider = FutureProvider<DynamicFormSchema>((ref) {
  return ref
      .watch(dynamicFormRepositoryProvider)
      .fetchSchema(MockDynamicFormApi.demoFormId);
});

/// Локальный fallback schema, если загрузка с сервера не удалась.
final dynamicFormDemoFallbackSchemaProvider =
    Provider<DynamicFormSchema>((ref) {
  return MockDynamicFormApi.demoSchema;
});
