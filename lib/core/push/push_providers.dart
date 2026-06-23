import 'package:base_flutter_proj/core/providers/app_event_provider.dart';
import 'package:base_flutter_proj/core/push/push_dispatcher.dart';
import 'package:base_flutter_proj/core/push/push_handler_module.dart';
import 'package:base_flutter_proj/core/push/push_pending_queue.dart';
import 'package:base_flutter_proj/core/push/push_registry.dart';
import 'package:base_flutter_proj/core/push/push_service.dart';
import 'package:base_flutter_proj/core/push/push_topic_manager.dart';
import 'package:base_flutter_proj/shop/push/shop_push_module.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Модули обработчиков от фич. Добавляйте сюда новые фичи.
final pushHandlerModulesProvider = Provider<List<PushHandlerModule>>((ref) {
  final modules = <PushHandlerModule>[ref.watch(shopPushModuleProvider)];
  return modules.where((module) => !module.isEmpty).toList(growable: false);
});

final pushRegistryProvider = Provider<PushRegistry>((ref) {
  final modules = ref.watch(pushHandlerModulesProvider);
  return PushRegistry.fromModules(modules);
});

final pushDispatcherProvider = Provider<PushDispatcher>((ref) {
  final registry = ref.watch(pushRegistryProvider);
  return PushDispatcher(
    registry: registry,
    emitEvent: (event) => ref.read(appEventProvider.notifier).emit(event),
  );
});

final pushServiceProvider = Provider<PushService>((ref) {
  final service = PushService(FirebaseMessaging.instance);
  ref.onDispose(service.dispose);
  return service;
});

final pushInitializationProvider = FutureProvider<void>((ref) async {
  final dispatcher = ref.read(pushDispatcherProvider);
  final service = ref.read(pushServiceProvider);

  await service.initialize(dispatcher);

  for (final message in PushPendingQueue.drain()) {
    dispatcher.dispatch(message);
  }
});

final pushTopicManagerProvider = Provider<PushTopicManager>((ref) {
  return PushTopicManager(ref.watch(pushServiceProvider));
});
