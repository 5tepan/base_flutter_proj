import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/push/push_delivery.dart';
import 'package:base_flutter_proj/core/push/push_handler_module.dart';
import 'package:base_flutter_proj/core/push/push_message.dart';
import 'package:base_flutter_proj/core/push/push_topics.dart';
import 'package:base_flutter_proj/core/push/push_types.dart';
import 'package:base_flutter_proj/shop/providers/shop_list_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final shopPushModuleProvider = Provider<PushHandlerModule>((ref) {
  return PushHandlerModule(
    typeHandlers: {
      PushType.shopOrderUpdate: (message, delivery) {
        _handleOrderUpdate(ref, message, delivery);
      },
      PushType.shopPromotion: (message, delivery) {
        _handlePromotion(ref, message, delivery);
      },
    },
    topicHandlers: {
      PushTopic.shopPromotions: (message, delivery) {
        _handlePromotion(ref, message, delivery);
      },
    },
  );
});

void _handleOrderUpdate(Ref ref, PushMessage message, PushDelivery delivery) {
  final orderId = message.dataString('order_id');
  CustomLogger.info(
    'Shop order push: orderId=$orderId, delivery=$delivery, data=${message.data}',
  );

  if (delivery.isUserInteraction && orderId != null) {
    // Навигация в детали заказа — добавьте route, когда появится экран.
    CustomLogger.info('Open order details: $orderId');
  }

  ref.read(shopListProvider.notifier).reload();
}

void _handlePromotion(Ref ref, PushMessage message, PushDelivery delivery) {
  final promoId = message.dataString('promo_id') ?? message.dataString('id');
  CustomLogger.info(
    'Shop promotion push: promoId=$promoId, topic=${message.topic}, delivery=$delivery',
  );

  if (delivery.isForeground) {
    // Можно показать in-app баннер через toast.
    return;
  }

  ref.read(shopListProvider.notifier).reload();
}
