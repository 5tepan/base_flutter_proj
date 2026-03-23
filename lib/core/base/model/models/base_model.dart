abstract class BaseModel {
  String? lastError;

  bool get hasError => lastError != null;

  void setError(Object error) {
    lastError = error.toString();
  }

  void clearError() {
    lastError = null;
  }
}
