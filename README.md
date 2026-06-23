# base_flutter_proj

Базовый Flutter-шаблон для мобильных приложений. Содержит готовую инфраструктуру: навигацию, авторизацию, сетевой слой, тему, локализацию и отладочные инструменты. На его основе можно быстро стартовать новый продукт, не собирая boilerplate с нуля.

## Что уже есть

| Модуль | Описание |
|--------|----------|
| **Auth** | Вход по телефону + SMS-код, маска RU (`PhoneInputHelper`), secure storage, refresh token, mock/real API |
| **Навигация** | go_router, типобезопасные маршруты, bottom tabs (Home / Shop / Profile) |
| **Сеть** | `BaseApi` + interceptors, Bearer token, retry при 401 |
| **State** | Riverpod 3 (`Notifier`, `AsyncNotifier`) |
| **UI** | Material 3, `ThemeBuilder`, формы, пагинация (`PaginatedNotifier`) |
| **Локализация** | ru / en через `intl_utils` (`lib/l10n/`, `make intl`) |
| **Отладка** | Talker, HTTP-логи, debug banner (dev), опциональный Firebase Crashlytics |
| **Push** | FCM (`firebase_messaging`): типы в `PushType`, топики в `PushTopic`, обработчики в модулях фич |
| **WebView** | Экран для политики конфиденциальности и документов |

Заглушки: **Home/Profile** — `PlaceholderPage`. **Shop** — эталонный экран списка с `PaginatedListView`.

## Стек

- Flutter SDK ^3.11
- Riverpod 3, go_router, http + http_interceptor
- flutter_secure_storage, smart_auth (SMS autofill на Android)
- firebase_core / firebase_crashlytics / firebase_messaging (опционально; ключи через env JSON)
- bottom_picker, intl — выбор даты/времени в формах

## Быстрый старт

```bash
# Зависимости
flutter pub get

# Кодогенерация (маршруты, JSON)
make generate

# Локализация (после правок ARB)
make intl

# Запуск dev (mock auth, debug banner)
make setup-secrets   # первый раз: создаёт .env и env/*.json из example
make run-dev

# Запуск prod
make run-prod

# Или напрямую:
flutter run --flavor dev --dart-define-from-file=env/dev.env.json
flutter run --flavor prod --dart-define-from-file=env/prod.env.json
```

### Mock-авторизация (dev)

При `useMockAuthApi: true` (по умолчанию в dev) бэкенд не нужен:

- Введите любой номер телефона (валидатор требует ≥18 символов с маской)
- Код подтверждения: **`1234`**

### Flavors

| Параметр | dev | prod |
|----------|-----|------|
| `apiUrlDomain` | localhost | api.myapp.com |
| `useMockAuthApi` | `true` | `false` |
| `showDebugBanner` | `true` | `false` |
| `enableFirebase` | `false` | `false` |
| `localeMode` | `russianAndEnglish` | `russianOnly` |
| Android `applicationId` | `com.base.base_flutter_proj` | `com.base.ru.baseflutterproj.prod` |
| iOS bundle ID | `com.base.base-flutter-proj` | `com.example.baseFlutterProj.prod` |

Конфиг: `lib/core/config.dart` + `lib/core/env_reader.dart`, значения — в `env/<flavor>.env.json`.

### Секреты и окружение

Секреты **не хранятся в репозитории**. Перед первым запуском:

```bash
make setup-secrets
```

| Файл | Назначение |
|------|------------|
| `.env` | Shell/CI: Team ID, Firebase App IDs |
| `env/dev.env.json` | Dart `--dart-define-from-file` для dev |
| `env/prod.env.json` | То же для prod |
| `secrets/google-services.json` | Firebase Android |
| `secrets/GoogleService-Info.plist` | Firebase iOS |
| `ios/Flutter/Secrets.xcconfig` | `DEVELOPMENT_TEAM` для Xcode |

Шаблоны: `.env.example`, `env/*.env.json.example`, `secrets/*.example`.

> Если секреты уже попали в git — **ротируйте ключи** в Firebase Console.

### Только русский язык

В `env/<flavor>.env.json` установите `"localeMode": "russianOnly"` — приложение всегда на русском. В prod-шаблоне это значение по умолчанию.

## Структура `lib/`

```
lib/
├── main.dart, runner.dart      # Точка входа (Config через EnvReader)
├── auth/                       # Авторизация (Repository → Api → Storage)
├── home/, shop/, profile/      # Табы
├── web_view/                   # WebView
├── l10n/                       # ARB-файлы (ru, en)
├── generated/                  # Сгенерированная локализация (S)
├── firebase_options.dart       # Firebase keys из --dart-define-from-file
└── core/                       # Инфраструктура
    ├── application.dart        # MaterialApp.router
    ├── app_bootstrap.dart      # Firebase + логгер
    ├── config.dart, env_reader.dart
    ├── push/                   # FCM: PushType, PushTopic, dispatcher, service
    ├── helpers/                # phone_input_helper, formatters/
    ├── providers/              # Riverpod (core, api, toast, theme)
    ├── router/                 # GoRouter, shell, access policy
    ├── network/                # CoreApi
    └── base/                   # BaseApi, формы, пагинация, scaffold
```

## Добавление feature API

1. Создать `*Api` extends `BaseApi` (или `CoreApi`) с методами эндпоинтов
2. Создать `*Repository` — бизнес-логика, маппинг ошибок
3. Зарегистрировать провайдеры (см. `lib/auth/providers/` и `lib/core/providers/api_providers.dart`)
4. UI → `Notifier` → `Repository` → `Api`

Для списков с подгрузкой — наследуйте `PaginatedNotifier<T>` + `PaginatedListView` (эталон: `lib/shop/`).

Для детального экрана — `ItemNotifier<T>` + `EntityStateBuilder`.

## Push-уведомления (опционально)

Требует `"enableFirebase": true` в `env/*.env.json` и настроенных Firebase-файлах.

**Каталог (единое место для всех фич):**

- `lib/core/push/push_types.dart` — числовые типы (`PushType.shopOrderUpdate = 1`)
- `lib/core/push/push_topics.dart` — FCM topics (`PushTopic.shopPromotions`)

**Обработчики в фиче** — `lib/<feature>/push/<feature>_push_module.dart`:

```dart
PushHandlerModule(
  typeHandlers: {
    PushType.shopOrderUpdate: (message, delivery) { ... },
  },
  topicHandlers: {
    PushTopic.shopPromotions: (message, delivery) { ... },
  },
)
```

Подключение модуля — в `pushHandlerModulesProvider` (`lib/core/push/push_providers.dart`).

Подписка на topic: `ref.read(pushTopicManagerProvider).subscribe(PushTopic.shopPromotions)`.

Парсер поддерживает `type` как `int` или `'1'`, на корне или внутри `data`.  
Эталон: `lib/shop/push/shop_push_module.dart`.

## Firebase (опционально)

1. Скопировать шаблоны: `make setup-secrets`
2. Положить `secrets/google-services.json` и `secrets/GoogleService-Info.plist` из Firebase Console
3. Заполнить Firebase keys в `env/dev.env.json` (см. `env/dev.env.json.example`)
4. В `.env` — `FIREBASE_ANDROID_APP_ID`, `FIREBASE_IOS_APP_ID` для CI distribution
5. Установить `"enableFirebase": true` в env JSON

По умолчанию Firebase выключен — шаблон работает без настройки. Push и Crashlytics активируются вместе с Firebase.

**App Distribution (dev):**

```bash
sh scripts/ci_android_dev_distribution.sh   # APK
sh scripts/ci_ios_dev_distribution.sh     # IPA (нужен paid Apple Developer + ad-hoc signing)
```

Package/bundle ID dev должны совпадать с Firebase Console (`com.base.base_flutter_proj` / `com.base.base-flutter-proj`).

## Локализация

- Исходники: `lib/l10n/intl_ru.arb`, `intl_en.arb`
- Генерация: `make intl` → `lib/generated/l10n.dart`
- В UI: `S.of(context).someKey`
- Ошибки API/auth: `AppErrorCode` + `ErrorLocalizer.message(code)` (`lib/core/l10n/error_localizer.dart`)
- Режим языков: `Config.localeMode` — `russianOnly` или `russianAndEnglish`

## Make-команды

| Команда | Действие |
|---------|----------|
| `make setup-secrets` | secrets → платформы, env/json, Secrets.xcconfig |
| `make run-dev` | flutter run dev flavor |
| `make run-prod` | flutter run prod flavor |
| `make generate` | build_runner (маршруты, JSON) |
| `make intl` | intl_utils:generate |
| `make createSplash` | нативный splash screen |
| `make toAssets` | генерация каталога ассетов |

Подробная карта проекта: `PROJECT_MAP.md` (локально, в `.gitignore`).
