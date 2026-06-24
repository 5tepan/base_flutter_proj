// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(phone) =>
      "На телефон ${phone} отправлено\nСМС с кодом подтверждения";

  static String m1(buttonText) =>
      "Нажимая на кнопку «${buttonText}», Вы\n соглашаетесь с ";

  static String m2(time) => "Повторная отправка через ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "apiBadRequestFormat": MessageLookupByLibrary.simpleMessage(
      "Некорректный формат запроса",
    ),
    "apiConnectionError": MessageLookupByLibrary.simpleMessage(
      "Ошибка подключения к интернету",
    ),
    "apiDataNotFound": MessageLookupByLibrary.simpleMessage(
      "Данные не найдены",
    ),
    "apiInvalidJson": MessageLookupByLibrary.simpleMessage(
      "Ответ сервера не является валидным JSON",
    ),
    "apiInvalidMeta": MessageLookupByLibrary.simpleMessage(
      "Не удалось разобрать meta часть запроса",
    ),
    "apiMissingData": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить data часть запроса",
    ),
    "apiMissingMeta": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить meta часть запроса",
    ),
    "apiNoInternet": MessageLookupByLibrary.simpleMessage(
      "Нет интернета. Попробуйте позже.",
    ),
    "apiParseError": MessageLookupByLibrary.simpleMessage(
      "Произошла ошибка. Попробуйте позже.",
    ),
    "apiRequestFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить запрос. Попробуйте еще раз",
    ),
    "apiUnknownError": MessageLookupByLibrary.simpleMessage(
      "Неизвестная ошибка. Попробуйте позже",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Base Flutter"),
    "authConfirmCodeError": MessageLookupByLibrary.simpleMessage(
      "Не удалось подтвердить код. Попробуйте позже",
    ),
    "authInvalidConfirmationCode": MessageLookupByLibrary.simpleMessage(
      "Неверный код подтверждения",
    ),
    "authPhoneRequired": MessageLookupByLibrary.simpleMessage(
      "Укажите номер телефона",
    ),
    "authPhoneTitle": MessageLookupByLibrary.simpleMessage(
      "Введите номер телефона,\nчтобы получить код подтверждения",
    ),
    "authRefreshSessionFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось обновить сессию",
    ),
    "authResendCodeError": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код повторно",
    ),
    "authResendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код повторно",
    ),
    "authSendCodeError": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код. Попробуйте позже",
    ),
    "authSendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код",
    ),
    "authSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Сессия истекла. Войдите снова",
    ),
    "authVerifyCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось подтвердить код",
    ),
    "codeSentToPhone": m0,
    "confirmationCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Продолжить"),
    "documentDefaultTitle": MessageLookupByLibrary.simpleMessage("Документ"),
    "enterCode": MessageLookupByLibrary.simpleMessage("Введите код"),
    "enterPhone": MessageLookupByLibrary.simpleMessage(
      "Введите номер телефона",
    ),
    "errorLoadingText": MessageLookupByLibrary.simpleMessage(
      "Данные не были загружены, пожалуйста, попробуйте еще раз",
    ),
    "errorLoadingTitle": MessageLookupByLibrary.simpleMessage(
      "Ошибка загрузки данных",
    ),
    "inDevelopment": MessageLookupByLibrary.simpleMessage("В разработке"),
    "navHome": MessageLookupByLibrary.simpleMessage("Главная"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "navShop": MessageLookupByLibrary.simpleMessage("Магазин"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "Вы не в сети. Проверьте подключение к Интернету.",
    ),
    "phoneInvalid": MessageLookupByLibrary.simpleMessage(
      "Введите корректный номер телефона",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Телефон"),
    "privacyAgreementAnd": MessageLookupByLibrary.simpleMessage("\nи c "),
    "privacyAgreementPrefix": m1,
    "privacyPolicy": MessageLookupByLibrary.simpleMessage(
      "Политикой конфиденциальности",
    ),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Политика конфиденциальности",
    ),
    "resendCodeButton": MessageLookupByLibrary.simpleMessage(
      "Отправить код повторно",
    ),
    "resendCodeIn": m2,
    "shopEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Товары появятся здесь",
    ),
    "shopEmptyTitle": MessageLookupByLibrary.simpleMessage("Пока пусто"),
    "shopLayoutGrid": MessageLookupByLibrary.simpleMessage("Сетка"),
    "shopLayoutList": MessageLookupByLibrary.simpleMessage("Список"),
    "shopProductDescription": MessageLookupByLibrary.simpleMessage("Описание"),
    "shopProductDetailTitle": MessageLookupByLibrary.simpleMessage("Товар"),
    "shopTitle": MessageLookupByLibrary.simpleMessage("Магазин"),
    "termsOfUse": MessageLookupByLibrary.simpleMessage(
      "Условиями использования",
    ),
    "termsOfUseTitle": MessageLookupByLibrary.simpleMessage(
      "Условия использования",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Попробовать снова"),
    "validationDateOfBirth": MessageLookupByLibrary.simpleMessage(
      "Выберите дату рождения",
    ),
    "validationEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Некорректный e-mail",
    ),
    "validationEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Введите e-mail",
    ),
    "validationFio": MessageLookupByLibrary.simpleMessage("Введите ФИО"),
    "validationName": MessageLookupByLibrary.simpleMessage("Введите имя"),
    "validationPasswordMin": MessageLookupByLibrary.simpleMessage(
      "не менее 6 символов",
    ),
    "validationPasswordMismatch": MessageLookupByLibrary.simpleMessage(
      "пароль должен совпадать",
    ),
    "validationRequiredField": MessageLookupByLibrary.simpleMessage(
      "Неверно заполнено поле",
    ),
    "validationSurname": MessageLookupByLibrary.simpleMessage(
      "Введите фамилию",
    ),
    "webViewNoUrl": MessageLookupByLibrary.simpleMessage(
      "Ссылка для отображения не передана",
    ),
  };
}
