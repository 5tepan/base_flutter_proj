/// Единый реестр числовых типов push-уведомлений.
///
/// Все типы объявляются только здесь — так не будет двух разных пушей с одним `type`.
/// Число может быть любым; диапазоны по фичам не обязательны, это лишь удобная
/// договорённость в больших проектах.
///
/// При добавлении:
/// 1. объявите `static const myFeatureSomething = N;`
/// 2. добавьте константу в [values] (для проверки уникальности в тестах)
/// 3. в обработчике используйте [PushType.myFeatureSomething] как ключ
abstract final class PushType {
  static const shopOrderUpdate = 1;
  static const shopPromotion = 2;

  /// Все зарегистрированные типы. Добавляйте сюда каждый новый тип.
  static const values = <int>[shopOrderUpdate, shopPromotion];
}
