/// Единый реестр FCM topics.
///
/// Все топики объявляются только здесь. Имена должны совпадать с backend/FCM Console.
abstract final class PushTopic {
  // --- Shop ---

  static const shopPromotions = 'shop_promotions';

  // --- Global ---

  static const broadcast = 'broadcast';

  /// Все зарегистрированные топики. Добавляйте сюда каждый новый топик.
  static const values = <String>[shopPromotions, broadcast];
}
