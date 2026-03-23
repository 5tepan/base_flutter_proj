import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = NotifierProvider<LoadingController, LoadingState>(
  LoadingController.new,
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

class LoadingController extends Notifier<LoadingState> {
  @override
  LoadingState build() {
    return const LoadingState();
  }

  void show({bool hideContent = false}) {
    state = state.copyWith(isLoading: true, hideContent: hideContent);
  }

  void hide() {
    state = const LoadingState();
  }
}
