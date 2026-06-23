import 'dart:async';

import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/push/push_delivery.dart';
import 'package:base_flutter_proj/core/push/push_dispatcher.dart';
import 'package:base_flutter_proj/core/push/push_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushService {
  PushService(this._messaging);

  final FirebaseMessaging _messaging;
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  Future<String?> get token => _messaging.getToken();

  Future<void> initialize(PushDispatcher dispatcher) async {
    await _requestPermission();
    await _configureForegroundPresentation();

    _subscriptions
      ..add(
        FirebaseMessaging.onMessage.listen((message) {
          dispatcher.dispatch(
            PushMessage.fromRemoteMessage(
              message,
              delivery: PushDelivery.foreground,
            ),
          );
        }),
      )
      ..add(
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          dispatcher.dispatch(
            PushMessage.fromRemoteMessage(
              message,
              delivery: PushDelivery.openedApp,
            ),
          );
        }),
      );

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      dispatcher.dispatch(
        PushMessage.fromRemoteMessage(
          initialMessage,
          delivery: PushDelivery.openedFromTerminated,
        ),
      );
    }

    CustomLogger.info('PushService initialized');
  }

  Future<void> subscribeToTopic(String topic) {
    CustomLogger.info('Push subscribe topic: $topic');
    return _messaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) {
    CustomLogger.info('Push unsubscribe topic: $topic');
    return _messaging.unsubscribeFromTopic(topic);
  }

  Future<void> dispose() async {
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission();
    CustomLogger.info('Push permission: ${settings.authorizationStatus}');
  }

  Future<void> _configureForegroundPresentation() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
