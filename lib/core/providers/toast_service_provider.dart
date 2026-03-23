import 'package:base_flutter_proj/core/services/toast_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toastServiceProvider = Provider<ToastService>((ref) {
  return ToastService();
});
