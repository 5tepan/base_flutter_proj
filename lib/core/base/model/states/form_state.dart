class FormState {
  final Map<String, dynamic> fields;
  final bool isSubmitting;
  final String? error;

  const FormState({
    this.fields = const {},
    this.isSubmitting = false,
    this.error,
  });

  FormState copyWith({
    Map<String, dynamic>? fields,
    bool? isSubmitting,
    String? error,
  }) {
    return FormState(
      fields: fields ?? this.fields,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}
