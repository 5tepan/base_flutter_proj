import 'dart:async';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/events/app_event.dart';
import 'package:base_flutter_proj/core/providers/app_event_provider.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/push/notification_badge_cleaner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Подписки на системные источники и проброс в [appEventProvider].
final appEventBindingsProvider = Provider<void>((ref) {
  ref.listen(appEventProvider, (previous, next) {
    if (next != null) {
      CustomLogger.info('AppEvent: $next');
    }
  });

  ref.listen(internetMonitorProvider, (previous, next) {
    final wasConnected = previous?.value;
    final isConnected = next.value;
    if (wasConnected == false && isConnected == true) {
      ref.read(appEventProvider.notifier).emit(const AppNetworkRestored());
    } else if (wasConnected == true && isConnected == false) {
      ref.read(appEventProvider.notifier).emit(const AppNetworkLost());
    }
  });
});

/// Наблюдатель lifecycle → [appEventProvider].
class AppLifecycleBridge extends ConsumerStatefulWidget {
  const AppLifecycleBridge({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<AppLifecycleBridge> createState() => _AppLifecycleBridgeState();
}

class _AppLifecycleBridgeState extends ConsumerState<AppLifecycleBridge>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(NotificationBadgeCleaner.clearOnAppOpen());
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final notifier = ref.read(appEventProvider.notifier);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        notifier.emit(const AppLifecyclePaused());
      case AppLifecycleState.resumed:
        notifier.emit(const AppLifecycleResumed());
        unawaited(NotificationBadgeCleaner.clearOnAppOpen());
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(appEventBindingsProvider);
    return widget.child;
  }
}
