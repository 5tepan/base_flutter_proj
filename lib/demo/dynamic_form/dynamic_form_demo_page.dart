import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/form_submit_helper.dart';
import 'package:base_flutter_proj/core/components/base_error_widget.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_notifier.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form_schema.dart';
import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/errors/app_exception.dart';
import 'package:base_flutter_proj/demo/dynamic_form/providers/dynamic_form_demo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Демо экран для проверки MVP динамических форм.
///
/// Schema загружается через repository (mock/real API);
/// при ошибке доступен fallback на локальный mock schema.
class DynamicFormDemoPage extends ConsumerStatefulWidget {
  const DynamicFormDemoPage({super.key});

  @override
  ConsumerState<DynamicFormDemoPage> createState() =>
      _DynamicFormDemoPageState();
}

class _DynamicFormDemoPageState extends ConsumerState<DynamicFormDemoPage> {
  final AppFormController _formController = AppFormController();

  String? _lastSubmitted;
  DynamicFormSchema? _fallbackSchema;

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schemaAsync = ref.watch(dynamicFormDemoSchemaProvider);
    final effectiveSchema = _fallbackSchema ?? schemaAsync.value;

    final isSubmitting = effectiveSchema == null
        ? false
        : ref.watch(
            dynamicFormProvider(effectiveSchema)
                .select((state) => state.isSubmitting),
          );

    return AppPageScaffold(
      appBarConfig: const AppPageAppBarConfig(title: 'Dynamic form demo'),
      isLoading: isSubmitting,
      body: schemaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _fallbackSchema == null
            ? _buildSchemaError(context, error)
            : _buildForm(_fallbackSchema!),
        data: (schema) => _buildForm(_fallbackSchema ?? schema),
      ),
    );
  }

  Widget _buildSchemaError(BuildContext context, Object error) {
    final appException = error is AppException ? error : null;

    return Column(
      children: [
        Expanded(
          child: BaseErrorWidget.fromError(
            context: context,
            errorCode: appException?.code ?? AppErrorCode.requestFailed,
            serverMessage: appException?.serverMessage,
            onPressedButton: () {
              ref.invalidate(dynamicFormDemoSchemaProvider);
            },
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _fallbackSchema = ref.read(dynamicFormDemoFallbackSchemaProvider);
            });
          },
          child: const Text('Use local mock schema'),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildForm(DynamicFormSchema schema) {
    final formProvider = dynamicFormProvider(schema);
    final formNotifier = ref.read(formProvider.notifier);
    final isSubmitting = ref.watch(
      formProvider.select((state) => state.isSubmitting),
    );

    return AppForm(
      controller: _formController,
      formType: AppFormType.normal,
      useSafeArea: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_fallbackSchema != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Using local mock schema (server load failed).',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          DynamicForm(
            schema: schema,
            controller: formNotifier.controller,
            enabled: !isSubmitting,
          ),
          const SizedBox(height: 12),
          if (_lastSubmitted != null)
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _lastSubmitted!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSubmitting ? null : () => _submit(schema),
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit(DynamicFormSchema schema) async {
    final formNotifier = ref.read(dynamicFormProvider(schema).notifier);

    await submitFormWithValidation(
      formController: _formController,
      onSubmit: () async {
        await formNotifier.submit((model) async {
          final json = model.fields.entries
              .map((entry) => '${entry.key}: ${entry.value}')
              .join(', ');
          if (mounted) {
            setState(() => _lastSubmitted = json);
          }
        });
      },
      onInvalidForm: () {
        setState(() {});
      },
    );
  }
}
