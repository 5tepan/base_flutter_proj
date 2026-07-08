# base_flutter_proj

Базовый Flutter-шаблон для мобильных приложений: навигация, авторизация, сеть, тема, локализация, пагинация, медиа, WebSocket, чаты и отладочные инструменты. На его основе можно быстро стартовать новый продукт без сборки boilerplate с нуля.

## Что уже есть

| Модуль | Кратко |
|--------|--------|
| **Auth** | Телефон + SMS, secure storage, refresh token, mock/real API |
| **Shop** | Эталон списка/сетки + деталка, Repository, push-модуль |
| **Chat** | Список комнат, переписка, REST + WebSocket, вложения, typing |
| **Навигация** | go_router, typed routes, bottom tabs (Home / Shop / Profile) |
| **Сеть** | `PublicApi` / `CoreApi`, interceptors, retry при 401 |
| **WebSocket** | Модульная подписка на каналы, mock/real клиент |
| **UI** | `AppPageScaffold`, пагинация, медиа/файлы, bottom sheet, календарь |
| **Настройки** | Server-driven `AppSettings` на splash |
| **Локализация** | ru / en (`make intl`) |
| **Push / Firebase** | Опционально, выключены по умолчанию |

Заглушки: **Home** — placeholder. **Profile** — хаб демо (медиа, календарь, чаты).

## Стек

Flutter ^3.11 · Riverpod 3 · go_router · http · flutter_secure_storage · hive · intl · image_picker / file_picker / share_plus и др. (полный список — `pubspec.yaml`).

## Быстрый старт

```bash
flutter pub get
make setup-secrets    # первый раз: .env и env/*.json из example
make generate         # маршруты, JSON
make intl             # после правок ARB
make run-dev          # dev flavor, mock API
```

Прямой запуск:

```bash
flutter run --flavor dev --dart-define-from-file=env/dev.env.json
```

### Mock-авторизация (dev)

При `USE_MOCK_AUTH_API=true` (по умолчанию в dev):

- Любой валидный номер с маской RU
- Код: **`1234`**

### Flavors и конфиг

| | dev | prod |
|---|-----|------|
| Mock API | вкл. | выкл. |
| Debug banner | да | нет |
| Локали | ru + en | ru (по умолчанию) |

Конфиг читается из `env/<flavor>.env.json` через `lib/core/env_reader.dart` → `lib/core/config.dart`.

Перед первым запуском: `make setup-secrets` (создаёт `.env`, `env/*.json` из example). Секреты и Firebase-файлы в репозиторий не коммитятся — шаблоны: `.env.example`, `env/*.env.json.example`, `secrets/*.example`.

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
└── core/          # инфраструктура (router, network, websocket, UI kit…)
```

Шаблон фичи: `api/` → `repository/` → `providers/` → `route/` → `*_page.dart`.

## Make-команды

| Команда | Действие |
|---------|----------|
| `make setup-secrets` | env, secrets, xcconfig |
| `make run-dev` / `make run-prod` | запуск flavor |
| `make generate` | build_runner |
| `make intl` | локализация |
| `make createSplash` | нативный splash |
| `make toAssets` | каталог ассетов |
