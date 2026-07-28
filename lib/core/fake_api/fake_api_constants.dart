/// Константы централизованного Fake API (шаблон / local UI без бэкенда).
abstract final class FakeApiConstants {
  /// SMS-код для `POST auth/verify-code` в fake-режиме.
  static const verificationCode = '1234';

  /// formId демо-формы: `GET forms/{id}/schema`.
  static const demoFormId = 'demo';

  /// Искусственная задержка ответов Fake API.
  static const latency = Duration(milliseconds: 350);

  /// Префикс asset-пути к JSON-фикстурам.
  static const assetsRoot = 'assets/fake_api';

  static const totalShopProducts = 45;
  static const shopErrorProductId = 'product_error';

  static const totalChatRooms = 12;
  static const messagesPerRoom = 48;
}
