# base_flutter_proj

Базовый Flutter-шаблон для мобильных приложений. Содержит готовую инфраструктуру: навигацию, авторизацию, сетевой слой, тему, локализацию и отладочные инструменты. На его основе можно быстро стартовать новый продукт, не собирая boilerplate с нуля.

Подробная карта проекта — в [`PROJECT_MAP.md`](PROJECT_MAP.md) (локальный файл, не в git).

## Что уже есть

| Модуль | Описание |
|--------|----------|
| **Auth** | Вход по телефону + SMS-код, secure storage, refresh token, mock/real API |
| **Навигация** | go_router, типобезопасные маршруты, bottom tabs (Home / Shop / Profile) |
| **Сеть** | `BaseApi` + interceptors, Bearer token, retry при 401 |
| **State** | Riverpod 3 (`Notifier`, `AsyncNotifier`) |
| **UI** | Material 3, `ThemeBuilder`, формы, пагинация (`PaginatedNotifier`) |
| **Локализация** | ru / en через `intl_utils` (`lib/l10n/`, `make intl`) |
| **Отладка** | Talker, HTTP-логи, debug banner (dev), опциональный Firebase Crashlytics |
| **WebView** | Экран для политики конфиденциальности и документов |

Заглушки: экраны **Shop** и часть **Home/Profile** — `PlaceholderPage` («В разработке»).

## Стек

- Flutter SDK ^3.11
- Riverpod 3, go_router, http + http_interceptor
- flutter_secure_storage, smart_auth (SMS autofill на Android)
- firebase_core / firebase_crashlytics (опционально)
- intl_utils для генерации `S` (локализация)

## Быстрый старт

```bash
# Зависимости
flutter pub get

# Кодогенерация (маршруты, JSON)
make generate

# Локализация (после правок ARB)
make intl

# Запуск dev (mock auth, debug banner)
flutter run --dart-define=FLAVOR=dev

# Запуск prod
flutter run --dart-define=FLAVOR=prod
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

Конфиг: `lib/core/config.dart`, выбор flavor — `lib/main.dart` (`FLAVOR` env).

## Структура `lib/`

```
lib/
├── main.dart, runner.dart      # Точка входа
├── auth/                       # Авторизация (Repository → Api → Storage)
├── home/, shop/, profile/       # Табы
├── web_view/                   # WebView
├── l10n/                       # ARB-файлы (ru, en)
├── generated/                  # Сгенерированная локализация (S)
├── firebase_options.dart       # Плейсхолдер — заменить после flutterfire configure
└── core/                       # Инфраструктура
    ├── application.dart        # MaterialApp.router
    ├── app_bootstrap.dart      # Firebase + логгер
    ├── config.dart
    ├── providers/              # Riverpod (core, api, toast)
    ├── router/                 # GoRouter, shell, access policy
    ├── network/                # CoreApi
    └── base/                   # BaseApi, формы, пагинация, scaffold
```

## Добавление feature API

1. Создать `*Api` extends `BaseApi` (или `CoreApi`) с методами эндпоинтов
2. Создать `*Repository` — бизнес-логика, маппинг ошибок
3. Зарегистрировать провайдеры (см. `lib/auth/providers/` и `lib/core/providers/api_providers.dart`)
4. UI → `Notifier` → `Repository` → `Api`

Для списков с подгрузкой — наследуйте `PaginatedNotifier<T>`.

## Firebase (опционально)

1. `dart pub global activate flutterfire_cli`
2. `flutterfire configure` — перезапишет `lib/firebase_options.dart`
3. Добавить `google-services.json` / `GoogleService-Info.plist`
4. В `lib/core/config.dart` установить `enableFirebase: true`

По умолчанию Firebase выключен — шаблон работает без настройки.

## Локализация

- Исходники: `lib/l10n/intl_ru.arb`, `intl_en.arb`
- Генерация: `make intl` → `lib/generated/l10n.dart`
- В UI: `S.of(context).someKey`
- В notifiers (после старта app): `S.current.someKey`

## Make-команды

| Команда | Действие |
|---------|----------|
| `make generate` | build_runner (маршруты, JSON) |
| `make intl` | intl_utils:generate |
| `make createSplash` | нативный splash screen |
| `make toAssets` | генерация каталога ассетов |

## Опциональные зависимости

Список пакетов, которые можно добавить по необходимости — в `docs/optional-deps.md`.
