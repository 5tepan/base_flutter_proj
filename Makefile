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
