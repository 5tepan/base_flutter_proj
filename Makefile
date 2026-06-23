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

setup-secrets:
	sh $(SCD)/setup_secrets.sh

run-dev:
	flutter run --flavor dev --dart-define-from-file=env/dev.env.json

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
