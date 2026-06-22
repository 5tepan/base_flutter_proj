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
    "appTitle": MessageLookupByLibrary.simpleMessage("Base Flutter"),
    "authConfirmCodeError": MessageLookupByLibrary.simpleMessage(
      "Не удалось подтвердить код. Попробуйте позже",
    ),
    "authPhoneTitle": MessageLookupByLibrary.simpleMessage(
      "Введите номер телефона,\nчтобы получить код подтверждения",
    ),
    "authResendCodeError": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код повторно",
    ),
    "authSendCodeError": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить код. Попробуйте позже",
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
    "termsOfUse": MessageLookupByLibrary.simpleMessage(
      "Условиями использования",
    ),
    "termsOfUseTitle": MessageLookupByLibrary.simpleMessage(
      "Условия использования",
    ),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Попробовать снова"),
    "webViewNoUrl": MessageLookupByLibrary.simpleMessage(
      "Ссылка для отображения не передана",
    ),
  };
}
