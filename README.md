# base_flutter_proj

Базовый Flutter-шаблон для мобильных приложений: навигация, авторизация, сеть, тема, локализация, пагинация, медиа, WebSocket, чаты и отладочные инструменты. На его основе можно быстро стартовать новый продукт без сборки boilerplate с нуля.

## Что уже есть

| Модуль | Кратко |
|--------|--------|
| **Auth** | Телефон + SMS, secure storage, refresh token, Fake/real API |
| **Shop** | Эталон списка/сетки + деталка, Repository, push-модуль |
| **Chat** | Список комнат, переписка, REST + WebSocket, вложения, typing |
| **Навигация** | go_router, typed routes, bottom tabs (Home / Shop / Profile) |
| **Сеть** | `PublicApi` / `CoreApi`, interceptors, retry при 401, Fake API |
| **WebSocket** | Модульная подписка на каналы, mock/real клиент |
| **UI** | `AppPageScaffold`, пагинация, медиа/файлы, карты (MapKit Lite), bottom sheet, календарь |
| **Настройки** | Server-driven `AppSettings` на splash |
| **Локализация** | ru / en (`make intl`) |
| **Push / Firebase** | Опционально, выключены по умолчанию |

Заглушки: **Home** — placeholder. **Profile** — хаб демо (медиа, календарь, карта, чаты).

## Стек

Flutter ^3.44 · Dart ^3.12 · Riverpod 3 · go_router · http · flutter_secure_storage · hive · intl · image_picker / file_picker / share_plus и др. (полный список — `pubspec.yaml`).

## Быстрый старт

```bash
flutter pub get    # генерирует Swift Package для iOS-плагинов
make setup-secrets    # первый раз: .env и env/*.json из example
make generate         # маршруты, JSON
make intl             # после правок ARB
make run-dev          # flavor dev, Fake API (без бэкенда)
make run-dev-backend  # flavor devbackend, реальный API
make run-web-dev      # Web в Chrome, dev-конфиг
```

Прямой запуск:

```bash
flutter run --flavor dev --dart-define-from-file=env/dev.env.json
```

```bash
flutter run --flavor devbackend --dart-define-from-file=env/dev-backend.env.json
```

Запуск в браузере:

```bash
make run-web-dev
make run-web-dev-backend
make run-web-prod
```

По умолчанию используется `web-server`: Flutter выводит локальный адрес, который можно открыть в Safari, Яндекс Браузере или другом браузере. Для запуска через Chrome передайте `WEB_DEVICE=chrome`, например `make run-web-dev WEB_DEVICE=chrome`.

`--flavor` в Flutter CLI выбирает Android product flavor или iOS scheme. Для Web используется конфиг приложения из env-файла: например, `make run-web-dev` передаёт `env/dev.env.json`, где задано `"FLAVOR": "dev"`.

### Fake API-авторизация (dev)

При `USE_FAKE_API=true` (по умолчанию в dev):

- Любой валидный номер с маской RU
- Код: **`1234`**

Моки REST живут в `assets/fake_api/` + `lib/core/fake_api/`.

### Flavors и конфиг

| | dev (Fake API) | devbackend (real backend) | prod |
|---|---|---|---|
| `USE_FAKE_API` | вкл. | выкл. | выкл. |
| `API_USE_HTTPS` | выкл. | выкл. | вкл., если ключ пустой |
| `USE_MOCK_WEBSOCKET` | вкл. | выкл. | выкл. |
| Debug banner | да | да | нет |
| Локали | ru + en | ru + en | ru (по умолчанию) |
| Application id | `com.base.baseflutterproj` | `com.base.baseflutterproj.devbackend` | `com.base.baseflutterproj.prod` |

Kotlin-пакет и method channel остаются `com.base.base_flutter_proj`. Менять их вместе с application id не нужно.

Конфиг читается из `env/<flavor>.env.json` через `lib/core/env_reader.dart` → `lib/core/config.dart`.

Перед первым запуском: `make setup-secrets` (создаёт `.env`, `env/*.json` из example). Секреты и Firebase-файлы в репозиторий не коммитятся — шаблоны: `.env.example`, `env/*.env.json.example`, `secrets/*.example`.

Release-сборка локально может быть подписана debug-ключом, пока нет `android/key.properties` (шаблон: `android/key.properties.example`). Скрипт дистрибуции `scripts/ci_android_dev_distribution.sh` в этом случае останавливается: в стор и Firebase App Distribution уходит только сборка со своим upload keystore.

## Структура `lib/` (кратко)

```
lib/
├── auth/          # эталон форм
├── shop/          # эталон списка + деталки
├── chat/          # чаты (REST + WebSocket)
├── home/          # таб-заглушка
├── profile/       # профиль + вложенные demo/chat routes
├── demo/          # демо-экраны компонентов
├── web_view/
└── core/          # инфраструктура (router, network, fake_api, websocket, UI kit…)
    └── platform/  # общие IO/Web-адаптеры за платформенно-независимыми API
```

Платформенные адаптеры для файлов, медиа и системного UI находятся в `lib/core/platform/`. Виджеты вызывают общий API; условные импорты выбирают IO- или Web-реализацию. UI-заглушки конкретной функции, например карты, остаются в модуле этой функции.

Шаблон фичи: `api/` → `repository/` → `providers/` → `route/` → `*_page.dart`.

## Контракт бэкенда

REST-ответ — объект `{ "data", "meta" }`. `meta.success: false` кладёт `meta.error` в сообщение для пользователя. Протухший access token — это HTTP 401 или `meta.invalidAccessToken` / `meta.invalid_access_token`. Refresh ходит на `POST auth/refresh` без Bearer, тело `{ "refresh_token" }`.

Список пагинируется с нуля: `page=0`, конец ленты — страница короче `pageSize`. Свой исходящий `sender_id` в Fake API — строка `me`; у реального пользователя такой id не используют.

WebSocket подключается на `/ws` и передаёт access token заголовком `Authorization: Bearer`, не в query.

## Что можно выключить

Модули оставлены в репозитории как конструктор. Если продукт их не использует, их лучше убрать из форка, а не тащить разрешения в стор.

| Модуль | Что удалить |
|--------|-------------|
| Карты | `yandex_maps_mapkit_lite`, `lib/core/components/map`, демо карты, `MAPKIT_API_KEY`, `ACCESS_FINE_LOCATION` / `ACCESS_COARSE_LOCATION`, `NSLocationWhenInUseUsageDescription`. После этого `minSdk` можно опустить ниже 26. |
| Медиа | `image_picker`, `file_picker`, `video_player`, `audioplayers`, `flutter_pdfview`, `croppy`, камера/микрофон/галерея в Android-манифесте и соответствующие строки в `Info.plist`. |
| Чаты | `lib/chat`, маршруты чата, `ENABLE_WEBSOCKET`. |
| Firebase / push | `ENABLE_FIREBASE=false` уже выключает инициализацию. Пакеты `firebase_*` и `POST_NOTIFICATIONS` удаляют, если пушей не будет. |
| Геолокация без карт | `geolocator`, `permission_handler`, location permissions. |

`make generate` после правок моделей и роутов. В CI имеет смысл падать, если после `dart run build_runner build --delete-conflicting-outputs` дерево грязное.

## Make-команды

| Команда | Действие |
|---------|----------|
| `make setup-secrets` | env, secrets, xcconfig |
| `make run-dev` / `make run-dev-backend` / `make run-prod` | запуск Android/iOS flavor |
| `make run-web-dev` / `make run-web-dev-backend` / `make run-web-prod` | запуск Web с соответствующим конфигом |
| `make generate` | build_runner |
| `make intl` | локализация |
| `make createSplash` | нативный splash |
| `make toAssets` | каталог ассетов |
