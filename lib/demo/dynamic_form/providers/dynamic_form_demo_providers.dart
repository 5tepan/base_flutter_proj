import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_constants.dart';
import 'package:base_flutter_proj/core/fake_api/fake_api_fixture_loader.dart';
import 'package:base_flutter_proj/core/providers/api_providers.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api.dart';
import 'package:base_flutter_proj/demo/dynamic_form/api/dynamic_form_api_impl.dart';
import 'package:base_flutter_proj/demo/dynamic_form/repository/dynamic_form_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dynamicFormApiProvider = Provider<DynamicFormApi>((ref) {
  return DynamicFormApiImpl(ref.watch(publicApiProvider));
});

final dynamicFormRepositoryProvider = Provider<DynamicFormRepository>((ref) {
  return DynamicFormRepository(ref.watch(dynamicFormApiProvider));
});

/// Загрузка schema демо-формы через API (Fake API или реальный бэкенд).
final dynamicFormDemoSchemaProvider =
    FutureProvider.autoDispose<DynamicFormSchema>((ref) {
  return ref
      .watch(dynamicFormRepositoryProvider)
      .fetchSchema(FakeApiConstants.demoFormId);
});

/// Локальный fallback schema из той же JSON-фикстуры.
final dynamicFormDemoFallbackSchemaProvider =
    FutureProvider.autoDispose<DynamicFormSchema>((ref) async {
  final envelope = await FakeApiFixtureLoader.loadEnvelope(
    'forms/demo.schema.get.json',
  );
  final data = envelope['data'] as Map<String, dynamic>;
  return DynamicFormSchema.fromJson(
    data['form_schema'] as Map<String, dynamic>,
  );
});
