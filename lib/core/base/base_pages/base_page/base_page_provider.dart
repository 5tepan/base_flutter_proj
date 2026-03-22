import 'package:base_flutter_proj/core/base/base_pages/services/toast_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final loadingProvider = StateNotifierProvider<LoadingController, LoadingState>(
  (ref) => LoadingController(),
);

class LoadingState {
  final bool isLoading;
  final bool hideContent;

  const LoadingState({this.isLoading = false, this.hideContent = false});

  LoadingState copyWith({bool? isLoading, bool? hideContent}) {
    return LoadingState(
      isLoading: isLoading ?? this.isLoading,
      hideContent: hideContent ?? this.hideContent,
    );
  }
}

class LoadingController extends StateNotifier<LoadingState> {
  LoadingController() : super(const LoadingState());

  void show({bool hideContent = false}) {
    state = state.copyWith(isLoading: true, hideContent: hideContent);
  }

  void hide() {
    state = const LoadingState();
  }
}

final toastServiceProvider = Provider<ToastService>((ref) {
  return ToastService();
});
