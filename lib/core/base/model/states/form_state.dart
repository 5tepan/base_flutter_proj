import 'package:base_flutter_proj/core/errors/app_error_code.dart';

class FormState {
  final Map<String, dynamic> fields;
  final bool isSubmitting;
  final AppErrorCode? errorCode;
  final String? serverMessage;

  const FormState({
    this.fields = const {},
    this.isSubmitting = false,
    this.errorCode,
    this.serverMessage,
  });

  bool get hasError => errorCode != null;

  FormState copyWith({
    Map<String, dynamic>? fields,
    bool? isSubmitting,
    AppErrorCode? errorCode,
    String? serverMessage,
    bool clearError = false,
  }) {
    return FormState(
      fields: fields ?? this.fields,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      serverMessage: clearError ? null : (serverMessage ?? this.serverMessage),
    );
  }
}
