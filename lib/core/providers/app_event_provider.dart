import 'package:base_flutter_proj/core/events/app_event.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppEventNotifier extends Notifier<AppEvent?> {
  @override
  AppEvent? build() => null;

  void emit(AppEvent event) {
    state = event;
  }
}

final appEventProvider =
    NotifierProvider<AppEventNotifier, AppEvent?>(AppEventNotifier.new);
