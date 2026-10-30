## Make-команды для запуска скриптов

# Директория скриптов
SCD := scripts


# В этот блок можно добавить скрипты уникальные для приложения
# --------------------------------
# somescript:
# 	sh $(SCD)/somescript.sh
# --------------------------------


# кодогенерация и т.д.
generate:
	sh $(SCD)/one_time_code_generation.sh

test:
	flutter test

setup-secrets:
	sh $(SCD)/setup_secrets.sh

# После pub get: MapKit Lite → CocoaPods (сломанный Package.swift), остальное → SPM
ios-spm-fix:
	sh $(SCD)/patch_yandex_mapkit_spm.sh

run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.env.json

run-dev-backend:
	flutter run --flavor devbackend --dart-define-from-file=env/dev-backend.env.json

run-prod:
	flutter run --flavor prod --dart-define-from-file=env/prod.env.json

toAssets:
	sh $(SCD)/asset_script.sh

createSplash:
	sh $(SCD)/create_native_splash.sh

# --------------------------------
# Сборка билдов
	
# --------------------------------
# Подписи и хеши

# --------------------------------
# Генерация локализации

intl:
	sh $(SCD)/intl_generate.sh
