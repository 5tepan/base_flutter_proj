import 'package:base_flutter_proj/core/components/app_bot_toast.dart';

class ToastService {
  void showMessage(String? message) {
    AppBotToast.showMessage(message);
  }

  void showError(String? message) {
    AppBotToast.showError(message);
  }
}
