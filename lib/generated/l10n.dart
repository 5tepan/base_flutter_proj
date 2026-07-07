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

  /// `Нет интернета. Попробуйте позже.`
  String get apiNoInternet {
    return Intl.message(
      'Нет интернета. Попробуйте позже.',
      name: 'apiNoInternet',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка подключения к интернету`
  String get apiConnectionError {
    return Intl.message(
      'Ошибка подключения к интернету',
      name: 'apiConnectionError',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестная ошибка. Попробуйте позже`
  String get apiUnknownError {
    return Intl.message(
      'Неизвестная ошибка. Попробуйте позже',
      name: 'apiUnknownError',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось отправить запрос. Попробуйте еще раз`
  String get apiRequestFailed {
    return Intl.message(
      'Не удалось отправить запрос. Попробуйте еще раз',
      name: 'apiRequestFailed',
      desc: '',
      args: [],
    );
  }

  /// `Данные не найдены`
  String get apiDataNotFound {
    return Intl.message(
      'Данные не найдены',
      name: 'apiDataNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Произошла ошибка. Попробуйте позже.`
  String get apiParseError {
    return Intl.message(
      'Произошла ошибка. Попробуйте позже.',
      name: 'apiParseError',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось получить meta часть запроса`
  String get apiMissingMeta {
    return Intl.message(
      'Не удалось получить meta часть запроса',
      name: 'apiMissingMeta',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось получить data часть запроса`
  String get apiMissingData {
    return Intl.message(
      'Не удалось получить data часть запроса',
      name: 'apiMissingData',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось разобрать meta часть запроса`
  String get apiInvalidMeta {
    return Intl.message(
      'Не удалось разобрать meta часть запроса',
      name: 'apiInvalidMeta',
      desc: '',
      args: [],
    );
  }

  /// `Некорректный формат запроса`
  String get apiBadRequestFormat {
    return Intl.message(
      'Некорректный формат запроса',
      name: 'apiBadRequestFormat',
      desc: '',
      args: [],
    );
  }

  /// `Ответ сервера не является валидным JSON`
  String get apiInvalidJson {
    return Intl.message(
      'Ответ сервера не является валидным JSON',
      name: 'apiInvalidJson',
      desc: '',
      args: [],
    );
  }

  /// `Укажите номер телефона`
  String get authPhoneRequired {
    return Intl.message(
      'Укажите номер телефона',
      name: 'authPhoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Неверный код подтверждения`
  String get authInvalidConfirmationCode {
    return Intl.message(
      'Неверный код подтверждения',
      name: 'authInvalidConfirmationCode',
      desc: '',
      args: [],
    );
  }

  /// `Сессия истекла. Войдите снова`
  String get authSessionExpired {
    return Intl.message(
      'Сессия истекла. Войдите снова',
      name: 'authSessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось отправить код`
  String get authSendCodeFailed {
    return Intl.message(
      'Не удалось отправить код',
      name: 'authSendCodeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось подтвердить код`
  String get authVerifyCodeFailed {
    return Intl.message(
      'Не удалось подтвердить код',
      name: 'authVerifyCodeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось отправить код повторно`
  String get authResendCodeFailed {
    return Intl.message(
      'Не удалось отправить код повторно',
      name: 'authResendCodeFailed',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось обновить сессию`
  String get authRefreshSessionFailed {
    return Intl.message(
      'Не удалось обновить сессию',
      name: 'authRefreshSessionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Выберите дату рождения`
  String get validationDateOfBirth {
    return Intl.message(
      'Выберите дату рождения',
      name: 'validationDateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Введите имя`
  String get validationName {
    return Intl.message(
      'Введите имя',
      name: 'validationName',
      desc: '',
      args: [],
    );
  }

  /// `Введите фамилию`
  String get validationSurname {
    return Intl.message(
      'Введите фамилию',
      name: 'validationSurname',
      desc: '',
      args: [],
    );
  }

  /// `Введите ФИО`
  String get validationFio {
    return Intl.message(
      'Введите ФИО',
      name: 'validationFio',
      desc: '',
      args: [],
    );
  }

  /// `Неверно заполнено поле`
  String get validationRequiredField {
    return Intl.message(
      'Неверно заполнено поле',
      name: 'validationRequiredField',
      desc: '',
      args: [],
    );
  }

  /// `не менее 6 символов`
  String get validationPasswordMin {
    return Intl.message(
      'не менее 6 символов',
      name: 'validationPasswordMin',
      desc: '',
      args: [],
    );
  }

  /// `Введите e-mail`
  String get validationEmailRequired {
    return Intl.message(
      'Введите e-mail',
      name: 'validationEmailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Некорректный e-mail`
  String get validationEmailInvalid {
    return Intl.message(
      'Некорректный e-mail',
      name: 'validationEmailInvalid',
      desc: '',
      args: [],
    );
  }

  /// `пароль должен совпадать`
  String get validationPasswordMismatch {
    return Intl.message(
      'пароль должен совпадать',
      name: 'validationPasswordMismatch',
      desc: '',
      args: [],
    );
  }

  /// `Магазин`
  String get shopTitle {
    return Intl.message('Магазин', name: 'shopTitle', desc: '', args: []);
  }

  /// `Пока пусто`
  String get shopEmptyTitle {
    return Intl.message(
      'Пока пусто',
      name: 'shopEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Товары появятся здесь`
  String get shopEmptySubtitle {
    return Intl.message(
      'Товары появятся здесь',
      name: 'shopEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Список`
  String get shopLayoutList {
    return Intl.message('Список', name: 'shopLayoutList', desc: '', args: []);
  }

  /// `Сетка`
  String get shopLayoutGrid {
    return Intl.message('Сетка', name: 'shopLayoutGrid', desc: '', args: []);
  }

  /// `Товар`
  String get shopProductDetailTitle {
    return Intl.message(
      'Товар',
      name: 'shopProductDetailTitle',
      desc: '',
      args: [],
    );
  }

  /// `Описание`
  String get shopProductDescription {
    return Intl.message(
      'Описание',
      name: 'shopProductDescription',
      desc: '',
      args: [],
    );
  }

  /// `Главная`
  String get navHome {
    return Intl.message('Главная', name: 'navHome', desc: '', args: []);
  }

  /// `Магазин`
  String get navShop {
    return Intl.message('Магазин', name: 'navShop', desc: '', args: []);
  }

  /// `Профиль`
  String get navProfile {
    return Intl.message('Профиль', name: 'navProfile', desc: '', args: []);
  }

  /// `Демо компонентов`
  String get profileDemoSectionTitle {
    return Intl.message(
      'Демо компонентов',
      name: 'profileDemoSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Примеры виджетов из core/components`
  String get profileDemoSectionSubtitle {
    return Intl.message(
      'Примеры виджетов из core/components',
      name: 'profileDemoSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Медиа и файлы`
  String get profileMediaDemoTitle {
    return Intl.message(
      'Медиа и файлы',
      name: 'profileMediaDemoTitle',
      desc: '',
      args: [],
    );
  }

  /// `Лента фото/видео, загрузка файлов, просмотр, шаринг`
  String get profileMediaDemoSubtitle {
    return Intl.message(
      'Лента фото/видео, загрузка файлов, просмотр, шаринг',
      name: 'profileMediaDemoSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Медиа и файлы`
  String get demoMediaFilesTitle {
    return Intl.message(
      'Медиа и файлы',
      name: 'demoMediaFilesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Фото (редактируемая лента)`
  String get demoPhotoSectionTitle {
    return Intl.message(
      'Фото (редактируемая лента)',
      name: 'demoPhotoSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Только изображения. При добавлении открывается croppy для обрезки.`
  String get demoPhotoSectionSubtitle {
    return Intl.message(
      'Только изображения. При добавлении открывается croppy для обрезки.',
      name: 'demoPhotoSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Фото и видео (mixed)`
  String get demoMixedSectionTitle {
    return Intl.message(
      'Фото и видео (mixed)',
      name: 'demoMixedSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Смешанная лента. С камеры — выбор фото или видео, из галереи — любой тип.`
  String get demoMixedSectionSubtitle {
    return Intl.message(
      'Смешанная лента. С камеры — выбор фото или видео, из галереи — любой тип.',
      name: 'demoMixedSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Только просмотр`
  String get demoReadOnlySectionTitle {
    return Intl.message(
      'Только просмотр',
      name: 'demoReadOnlySectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Те же элементы, что в mixed-ленте, но без кнопок добавления и удаления.`
  String get demoReadOnlySectionSubtitle {
    return Intl.message(
      'Те же элементы, что в mixed-ленте, но без кнопок добавления и удаления.',
      name: 'demoReadOnlySectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка файлов`
  String get demoFilesSectionTitle {
    return Intl.message(
      'Загрузка файлов',
      name: 'demoFilesSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `PDF, документы и другие типы через file_picker.`
  String get demoFilesSectionSubtitle {
    return Intl.message(
      'PDF, документы и другие типы через file_picker.',
      name: 'demoFilesSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Шаринг`
  String get demoShareSectionTitle {
    return Intl.message(
      'Шаринг',
      name: 'demoShareSectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `share_plus — ссылка, текст и выбранные файлы.`
  String get demoShareSectionSubtitle {
    return Intl.message(
      'share_plus — ссылка, текст и выбранные файлы.',
      name: 'demoShareSectionSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Демо ссылка из приложения`
  String get demoShareLinkText {
    return Intl.message(
      'Демо ссылка из приложения',
      name: 'demoShareLinkText',
      desc: '',
      args: [],
    );
  }

  /// `Поделиться текстом`
  String get demoShareTextButton {
    return Intl.message(
      'Поделиться текстом',
      name: 'demoShareTextButton',
      desc: '',
      args: [],
    );
  }

  /// `Поделиться файлами`
  String get demoShareFilesButton {
    return Intl.message(
      'Поделиться файлами',
      name: 'demoShareFilesButton',
      desc: '',
      args: [],
    );
  }

  /// `Скопировать mixed-ленту в режим просмотра`
  String get demoSyncMixedButton {
    return Intl.message(
      'Скопировать mixed-ленту в режим просмотра',
      name: 'demoSyncMixedButton',
      desc: '',
      args: [],
    );
  }

  /// `Вложения`
  String get demoAttachmentsLabel {
    return Intl.message(
      'Вложения',
      name: 'demoAttachmentsLabel',
      desc: '',
      args: [],
    );
  }

  /// `Добавить медиа`
  String get mediaFeedAddTitle {
    return Intl.message(
      'Добавить медиа',
      name: 'mediaFeedAddTitle',
      desc: '',
      args: [],
    );
  }

  /// `Камера`
  String get mediaFeedCamera {
    return Intl.message('Камера', name: 'mediaFeedCamera', desc: '', args: []);
  }

  /// `Галерея`
  String get mediaFeedGallery {
    return Intl.message(
      'Галерея',
      name: 'mediaFeedGallery',
      desc: '',
      args: [],
    );
  }

  /// `Фото`
  String get mediaFeedPhoto {
    return Intl.message('Фото', name: 'mediaFeedPhoto', desc: '', args: []);
  }

  /// `Видео`
  String get mediaFeedVideo {
    return Intl.message('Видео', name: 'mediaFeedVideo', desc: '', args: []);
  }

  /// `{current} / {total}`
  String mediaFeedGalleryCounter(int current, int total) {
    return Intl.message(
      '$current / $total',
      name: 'mediaFeedGalleryCounter',
      desc: '',
      args: [current, total],
    );
  }

  /// `Файлы не выбраны`
  String get fileListEmpty {
    return Intl.message(
      'Файлы не выбраны',
      name: 'fileListEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать файлы`
  String get filePickButton {
    return Intl.message(
      'Выбрать файлы',
      name: 'filePickButton',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось выбрать файлы`
  String get filePickError {
    return Intl.message(
      'Не удалось выбрать файлы',
      name: 'filePickError',
      desc: '',
      args: [],
    );
  }

  /// `Файл`
  String get fileViewerTitle {
    return Intl.message('Файл', name: 'fileViewerTitle', desc: '', args: []);
  }

  /// `Медиа`
  String get fileViewerMediaTitle {
    return Intl.message(
      'Медиа',
      name: 'fileViewerMediaTitle',
      desc: '',
      args: [],
    );
  }

  /// `Предпросмотр недоступен`
  String get fileViewerPreviewUnavailable {
    return Intl.message(
      'Предпросмотр недоступен',
      name: 'fileViewerPreviewUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Локальный файл недоступен`
  String get fileViewerLocalUnavailable {
    return Intl.message(
      'Локальный файл недоступен',
      name: 'fileViewerLocalUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось сохранить файл`
  String get fileViewerSaveFailed {
    return Intl.message(
      'Не удалось сохранить файл',
      name: 'fileViewerSaveFailed',
      desc: '',
      args: [],
    );
  }

  /// `Сохранено: {path}`
  String fileViewerSaved(String path) {
    return Intl.message(
      'Сохранено: $path',
      name: 'fileViewerSaved',
      desc: '',
      args: [path],
    );
  }

  /// `Пауза`
  String get fileAudioPause {
    return Intl.message('Пауза', name: 'fileAudioPause', desc: '', args: []);
  }

  /// `Воспроизвести`
  String get fileAudioPlay {
    return Intl.message(
      'Воспроизвести',
      name: 'fileAudioPlay',
      desc: '',
      args: [],
    );
  }

  /// `Поделиться`
  String get shareButton {
    return Intl.message('Поделиться', name: 'shareButton', desc: '', args: []);
  }

  /// `Поделиться ссылкой`
  String get shareLinkButton {
    return Intl.message(
      'Поделиться ссылкой',
      name: 'shareLinkButton',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать`
  String get dateTimeSelect {
    return Intl.message('Выбрать', name: 'dateTimeSelect', desc: '', args: []);
  }

  /// `Выберите время`
  String get dateTimeSelectTime {
    return Intl.message(
      'Выберите время',
      name: 'dateTimeSelectTime',
      desc: '',
      args: [],
    );
  }

  /// `Выберите год`
  String get dateTimeSelectYear {
    return Intl.message(
      'Выберите год',
      name: 'dateTimeSelectYear',
      desc: '',
      args: [],
    );
  }

  /// `Да`
  String get universalModalYes {
    return Intl.message('Да', name: 'universalModalYes', desc: '', args: []);
  }

  /// `Нет`
  String get universalModalNo {
    return Intl.message('Нет', name: 'universalModalNo', desc: '', args: []);
  }

  /// `Ок`
  String get universalModalOk {
    return Intl.message('Ок', name: 'universalModalOk', desc: '', args: []);
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
