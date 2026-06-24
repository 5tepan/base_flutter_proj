import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:flutter/widgets.dart';

/// Валидация и submit формы. Loading — через `isSubmitting` на странице
/// (например `AppPageScaffold.isLoading`), не через глобальный provider.
Future<void> submitFormWithValidation({
  required AppFormController formController,
  required Future<void> Function() onSubmit,
  VoidCallback? onInvalidForm,
}) async {
  if (formController.isSubmitting) {
    return;
  }

  formController.isSubmitting = true;

  final isValid = await formController.validate();
  if (!isValid) {
    formController.enableAutovalidate();
    onInvalidForm?.call();
    formController.isSubmitting = false;
    return;
  }

  formController.save();
  FocusManager.instance.primaryFocus?.unfocus();

  try {
    await onSubmit();
  } finally {
    formController.isSubmitting = false;
  }
}
