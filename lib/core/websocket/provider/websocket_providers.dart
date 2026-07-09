import 'package:base_flutter_proj/chat/socket/chat_socket_module.dart';
import 'package:base_flutter_proj/core/providers/app_event_provider.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:base_flutter_proj/core/websocket/client/fastapi_websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/client/mock_websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/client/websocket_client.dart';
import 'package:base_flutter_proj/core/websocket/handler/websocket_dispatcher.dart';
import 'package:base_flutter_proj/core/websocket/handler/websocket_registry.dart';
import 'package:base_flutter_proj/core/websocket/model/websocket_handler_module.dart';
import 'package:base_flutter_proj/core/websocket/service/websocket_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Модули WebSocket-подписок от фич. Добавляйте сюда новые фичи (например, chat).
final webSocketHandlerModulesProvider =
    Provider<List<WebSocketHandlerModule>>((ref) {
  final modules = <WebSocketHandlerModule>[
    ref.watch(chatSocketModuleProvider),
  ];
  return modules.where((module) => !module.isEmpty).toList(growable: false);
});

final webSocketRegistryProvider = Provider<WebSocketRegistry>((ref) {
  final modules = ref.watch(webSocketHandlerModulesProvider);
  return WebSocketRegistry.fromModules(modules);
});

final webSocketDispatcherProvider = Provider<WebSocketDispatcher>((ref) {
  final registry = ref.watch(webSocketRegistryProvider);
  return WebSocketDispatcher(
    registry: registry,
    emitEvent: (event) => ref.read(appEventProvider.notifier).emit(event),
  );
});

final webSocketClientProvider = Provider<WebSocketClient>((ref) {
  final config = ref.watch(configProvider);
  if (config.useMockWebSocket) {
    final client = MockWebSocketClient();
    ref.onDispose(client.dispose);
    return client;
  }
  final client = FastApiWebSocketClient(config: config);
  ref.onDispose(client.dispose);
  return client;
});

final webSocketServiceProvider = Provider<WebSocketService>((ref) {
  final service = WebSocketService(
    client: ref.watch(webSocketClientProvider),
    registry: ref.watch(webSocketRegistryProvider),
    dispatcher: ref.watch(webSocketDispatcherProvider),
    checkConnection: () => ref.read(connectivityCheckProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});
