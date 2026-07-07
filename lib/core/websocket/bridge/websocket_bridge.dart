import 'dart:async';

import 'package:base_flutter_proj/auth/providers/auth_providers.dart';
import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';
import 'package:base_flutter_proj/core/events/app_event.dart';
import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/providers/app_event_provider.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/websocket/provider/websocket_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Инициализирует WebSocket после старта [ProviderScope].
class WebSocketBridge extends ConsumerWidget {
  const WebSocketBridge({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final shouldInit = config.enableWebSocket && !AppPlatform.isWeb;

    if (shouldInit) {
      ref.watch(webSocketLifecycleProvider);
    }

    return child;
  }
}

final webSocketLifecycleProvider = Provider<void>((ref) {
  final config = ref.read(configProvider);
  if (!config.enableWebSocket || AppPlatform.isWeb) {
    return;
  }

  final service = ref.read(webSocketServiceProvider);

  Future<void> connectIfAuthorized(AuthSession? session) async {
    if (session == null || session.accessToken.isEmpty) {
      await service.disconnect();
      return;
    }
    await service.connect(accessToken: session.accessToken);
  }

  ref.listen<AsyncValue<AuthSession?>>(
    authSessionProvider,
    (previous, next) {
      if (next.isLoading) {
        return;
      }
      unawaited(connectIfAuthorized(next.value));
    },
    fireImmediately: true,
  );

  ref.listen<AppEvent?>(appEventProvider, (previous, next) {
    if (next is! AppNetworkRestored && next is! AppLifecycleResumed) {
      return;
    }

    final session = ref.read(authSessionProvider).value;
    if (session == null) {
      return;
    }

    unawaited(service.reconnect(accessToken: session.accessToken));
  });
});
