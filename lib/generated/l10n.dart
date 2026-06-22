// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Base Flutter`
  String get appTitle {
    return Intl.message('Base Flutter', name: 'appTitle', desc: '', args: []);
  }

  /// `Продолжить`
  String get continueButton {
    return Intl.message(
      'Продолжить',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Введите номер телефона,\nчтобы получить код подтверждения`
  String get authPhoneTitle {
    return Intl.message(
      'Введите номер телефона,\nчтобы получить код подтверждения',
      name: 'authPhoneTitle',
      desc: '',
      args: [],
    );
  }

  /// `Телефон`
  String get phoneLabel {
    return Intl.message('Телефон', name: 'phoneLabel', desc: '', args: []);
  }

  /// `Код подтверждения`
  String get confirmationCodeLabel {
    return Intl.message(
      'Код подтверждения',
      name: 'confirmationCodeLabel',
      desc: '',
      args: [],
    );
  }

  /// `На телефон {phone} отправлено\nСМС с кодом подтверждения`
  String codeSentToPhone(String phone) {
    return Intl.message(
      'На телефон $phone отправлено\nСМС с кодом подтверждения',
      name: 'codeSentToPhone',
      desc: '',
      args: [phone],
    );
  }

  /// `Повторная отправка через {time}`
  String resendCodeIn(String time) {
    return Intl.message(
      'Повторная отправка через $time',
      name: 'resendCodeIn',
      desc: '',
      args: [time],
    );
  }

  /// `Отправить код повторно`
  String get resendCodeButton {
    return Intl.message(
      'Отправить код повторно',
      name: 'resendCodeButton',
      desc: '',
      args: [],
    );
  }

  /// `Вы не в сети. Проверьте подключение к Интернету.`
  String get noInternet {
    return Intl.message(
      'Вы не в сети. Проверьте подключение к Интернету.',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  /// `В разработке`
  String get inDevelopment {
    return Intl.message(
      'В разработке',
      name: 'inDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Нажимая на кнопку «{buttonText}», Вы\n соглашаетесь с `
  String privacyAgreementPrefix(String buttonText) {
    return Intl.message(
      'Нажимая на кнопку «$buttonText», Вы\n соглашаетесь с ',
      name: 'privacyAgreementPrefix',
      desc: '',
      args: [buttonText],
    );
  }

  /// `Политикой конфиденциальности`
  String get privacyPolicy {
    return Intl.message(
      'Политикой конфиденциальности',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `\nи c `
  String get privacyAgreementAnd {
    return Intl.message(
      '\nи c ',
      name: 'privacyAgreementAnd',
      desc: '',
      args: [],
    );
  }

  /// `Условиями использования`
  String get termsOfUse {
    return Intl.message(
      'Условиями использования',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Условия использования`
  String get termsOfUseTitle {
    return Intl.message(
      'Условия использования',
      name: 'termsOfUseTitle',
      desc: '',
      args: [],
    );
  }

  /// `Политика конфиденциальности`
  String get privacyPolicyTitle {
    return Intl.message(
      'Политика конфиденциальности',
      name: 'privacyPolicyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Документ`
  String get documentDefaultTitle {
    return Intl.message(
      'Документ',
      name: 'documentDefaultTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ссылка для отображения не передана`
  String get webViewNoUrl {
    return Intl.message(
      'Ссылка для отображения не передана',
      name: 'webViewNoUrl',
      desc: '',
      args: [],
    );
  }

  /// `Попробовать снова`
  String get tryAgain {
    return Intl.message(
      'Попробовать снова',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки данных`
  String get errorLoadingTitle {
    return Intl.message(
      'Ошибка загрузки данных',
      name: 'errorLoadingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Данные не были загружены, пожалуйста, попробуйте еще раз`
  String get errorLoadingText {
    return Intl.message(
      'Данные не были загружены, пожалуйста, попробуйте еще раз',
      name: 'errorLoadingText',
      desc: '',
      args: [],
    );
  }

  /// `Введите код`
  String get enterCode {
    return Intl.message('Введите код', name: 'enterCode', desc: '', args: []);
  }

  /// `Введите номер телефона`
  String get enterPhone {
    return Intl.message(
      'Введите номер телефона',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Введите корректный номер телефона`
  String get phoneInvalid {
    return Intl.message(
      'Введите корректный номер телефона',
      name: 'phoneInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось отправить код. Попробуйте позже`
  String get authSendCodeError {
    return Intl.message(
      'Не удалось отправить код. Попробуйте позже',
      name: 'authSendCodeError',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось подтвердить код. Попробуйте позже`
  String get authConfirmCodeError {
    return Intl.message(
      'Не удалось подтвердить код. Попробуйте позже',
      name: 'authConfirmCodeError',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось отправить код повторно`
  String get authResendCodeError {
    return Intl.message(
      'Не удалось отправить код повторно',
      name: 'authResendCodeError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
