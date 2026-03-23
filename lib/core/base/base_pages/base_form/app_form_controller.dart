import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class AppFormController {
  AppFormController({this.shouldScrollToErrorField = true});

  final bool shouldScrollToErrorField;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AutoScrollController scrollController = AutoScrollController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool isSubmitting = false;

  Future<bool> validate() async {
    final formState = formKey.currentState;
    if (formState == null) return false;

    final invalidFields = formState.validateGranularly();
    final isValid = invalidFields.isEmpty;

    if (!isValid && shouldScrollToErrorField) {
      final firstInvalid = invalidFields.firstOrNull;
      if (firstInvalid != null) {
        scrollToField(firstInvalid);
      }
    }

    return isValid;
  }

  void scrollToField(FormFieldState<Object?> field) {
    final renderObject = field.context.findRenderObject();
    if (renderObject is RenderObject) {
      renderObject.showOnScreen(duration: Durations.short4);
    }
  }

  void save() {
    formKey.currentState?.save();
  }

  void enableAutovalidate() {
    autovalidateMode = AutovalidateMode.always;
  }

  void dispose() {
    scrollController.dispose();
  }
}
