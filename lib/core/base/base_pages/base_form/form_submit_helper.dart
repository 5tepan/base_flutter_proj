import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:base_flutter_proj/core/providers/loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> submitFormWithValidation({
  required AppFormController formController,
  required Future<void> Function() onSubmit,
  BuildContext? context,
  WidgetRef? ref,
  bool hideContentOnLoading = false,
  bool saveForm = true,
  bool unfocusOnSubmit = true,
  VoidCallback? onInvalidForm,
}) async {
  if (formController.isSubmitting || (context != null && !context.mounted)) {
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

  if (saveForm) {
    formController.save();
  }
  if (unfocusOnSubmit) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  final loading = ref?.read(loadingProvider.notifier);
  loading?.show(hideContent: hideContentOnLoading);

  try {
    await onSubmit();
  } finally {
    loading?.hide();
    formController.isSubmitting = false;
  }
}
