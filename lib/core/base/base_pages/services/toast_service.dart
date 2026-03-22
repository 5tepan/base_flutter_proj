import 'package:base_flutter_proj/core/base/base_pages/components/app_bot_toast.dart';

class ToastService {
  void showMessage(String? message) {
    AppBotToast.showMessage(message);
  }

  void showError(String? message) {
    AppBotToast.showError(message);
  }
}
