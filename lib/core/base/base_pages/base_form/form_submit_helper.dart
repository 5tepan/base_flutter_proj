import 'package:base_flutter_proj/core/base/base_pages/base_form/app_form_controller.dart';
import 'package:base_flutter_proj/core/providers/loading_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> submitFormWithValidation({
  required BuildContext context,
  required WidgetRef ref,
  required AppFormController formController,
  required Future<void> Function() onSubmit,
  bool hideContentOnLoading = false,
}) async {
  if (formController.isSubmitting || !context.mounted) {
    return;
  }

  formController.enableAutovalidate();

  formController.isSubmitting = true;

  final isValid = await formController.validate();
  if (!isValid) {
    formController.isSubmitting = false;
    return;
  }

  formController.save();
  FocusManager.instance.primaryFocus?.unfocus();

  final loading = ref.read(loadingProvider.notifier);
  loading.show(hideContent: hideContentOnLoading);

  try {
    await onSubmit();
  } finally {
    loading.hide();
    formController.isSubmitting = false;
  }
}
