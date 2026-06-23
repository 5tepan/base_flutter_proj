import 'package:base_flutter_proj/core/app_bootstrap.dart';
import 'package:base_flutter_proj/core/push/push_delivery.dart';
import 'package:base_flutter_proj/core/push/push_message.dart';
import 'package:base_flutter_proj/core/push/push_pending_queue.dart';
import 'package:base_flutter_proj/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Background isolate handler. Регистрируется в [main] до [runApp].
@pragma('vm:entry-point')
Future<void> pushBackgroundHandler(RemoteMessage message) async {
  if (!AppBootstrap.isFirebaseInitialized) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AppBootstrap.isFirebaseInitialized = true;
    } catch (error, stackTrace) {
      debugPrint('Push background Firebase init failed: $error');
      debugPrint('$stackTrace');
      return;
    }
  }

  final pushMessage = PushMessage.fromRemoteMessage(
    message,
    delivery: PushDelivery.backgroundData,
  );
  PushPendingQueue.enqueue(pushMessage);
}
