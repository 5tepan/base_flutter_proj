import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';

mixin LoadingNotifierMixin<T extends StatefulWidget> on State<T> {
  bool _isScreenLoading = false;
  void Function()? _removeLoadingListener;

  bool get isScreenLoading => _isScreenLoading;

  void bindLoading<S>({
    required StateNotifier<S> notifier,
    required bool Function(S state) selectIsLoading,
    bool fireImmediately = true,
  }) {
    _removeLoadingListener?.call();
    _removeLoadingListener = notifier.addListener((state) {
      final nextValue = selectIsLoading(state);
      if (!mounted || _isScreenLoading == nextValue) {
        return;
      }
      setState(() => _isScreenLoading = nextValue);
    }, fireImmediately: fireImmediately);
  }

  @override
  void dispose() {
    _removeLoadingListener?.call();
    super.dispose();
  }
}
