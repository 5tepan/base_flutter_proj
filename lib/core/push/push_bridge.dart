import 'package:base_flutter_proj/core/app_bootstrap.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/push/push_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Инициализирует push после старта [ProviderScope].
class PushBridge extends ConsumerWidget {
  const PushBridge({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final shouldInit =
        config.enableFirebase && AppBootstrap.isFirebaseInitialized && !AppPlatform.isWeb;

    if (shouldInit) {
      ref.watch(pushInitializationProvider);
    }

    return child;
  }
}
