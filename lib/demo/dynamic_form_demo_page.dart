import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:base_flutter_proj/core/base/base_pages/base_form/form_submit_helper.dart';
import 'package:base_flutter_proj/core/components/dynamic_form/dynamic_form.dart';
import 'package:base_flutter_proj/demo/dynamic_form_demo_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Демо экран для проверки MVP динамических форм.
///
/// Сейчас schema захардкожен (без сервера), чтобы сосредоточиться
/// на UI/рендерере/валидации.
class DynamicFormDemoPage extends ConsumerStatefulWidget {
  const DynamicFormDemoPage({super.key});

  @override
  ConsumerState<DynamicFormDemoPage> createState() =>
      _DynamicFormDemoPageState();
}

class _DynamicFormDemoPageState extends ConsumerState<DynamicFormDemoPage> {
  final AppFormController _formController = AppFormController();

  String? _lastSubmitted;

  @override
  void dispose() {
    _formController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = ref.watch(
      dynamicFormDemoProvider.select((state) => state.isSubmitting),
    );
    final formNotifier = ref.read(dynamicFormDemoProvider.notifier);

    return AppPageScaffold(
      appBarConfig: const AppPageAppBarConfig(title: 'Dynamic form demo'),
      isLoading: isSubmitting,
      body: AppForm(
        controller: _formController,
        formType: AppFormType.normal,
        useSafeArea: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DynamicForm(
              schema: dynamicFormDemoSchema,
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
                onPressed: isSubmitting ? null : _submit,
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final formNotifier = ref.read(dynamicFormDemoProvider.notifier);

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
