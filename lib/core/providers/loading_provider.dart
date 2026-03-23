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
