#!/bin/sh

# Скрипт:
# 1. Берет png, @2x, @3x из корня проекта
# 2. Перемещает их в assets, assets/2.0x, assets/3.0x
# 3. Добавляет запись в AssetsCatalog

ASSETS_CATALOG="lib/core/helpers/assets_catalog.dart"

read -p "Введите имя ассета без .png: " name

if [ -z "$name" ]; then
    echo "Некорректное имя ассета"
    exit 1
fi

# Ищем базовое имя файла по *@3x.png
filename=$(ls ./*@3x.png 2>/dev/null | head -n 1 | xargs -n 1 basename | sed 's/@3x\.png$//')

if [ -z "$filename" ]; then
    echo "Не найден файл вида *@3x.png в корне проекта"
    exit 1
fi

if [ ! -f "./${filename}.png" ]; then
    echo "Не найден файл ${filename}.png"
    exit 1
fi

if [ ! -f "./${filename}@2x.png" ]; then
    echo "Не найден файл ${filename}@2x.png"
    exit 1
fi

if [ ! -f "./${filename}@3x.png" ]; then
    echo "Не найден файл ${filename}@3x.png"
    exit 1
fi

mkdir -p assets assets/2.0x assets/3.0x

mv "./${filename}.png" "assets/${name}.png"
mv "./${filename}@2x.png" "assets/2.0x/${name}.png"
mv "./${filename}@3x.png" "assets/3.0x/${name}.png"

# Преобразование имени файла в camelCase для Dart-константы
# пример:
# ic_logo -> icLogo
# icon_play_video -> iconPlayVideo
const_name=$(echo "$name" | awk -F '_' '{
    for (i = 1; i <= NF; i++) {
        if (i == 1) {
            printf "%s", tolower($i)
        } else {
            printf "%s%s", toupper(substr($i,1,1)), tolower(substr($i,2))
        }
    }
}')

new_line="  static const String ${const_name} = 'assets/${name}.png';"

if [ ! -f "$ASSETS_CATALOG" ]; then
    echo "Файл $ASSETS_CATALOG не найден"
    exit 1
fi

# Проверяем, нет ли уже такой константы или такого пути
if grep -q "static const String ${const_name} =" "$ASSETS_CATALOG"; then
    echo "Константа ${const_name} уже существует в AssetsCatalog"
    exit 0
fi

if grep -q "'assets/${name}.png'" "$ASSETS_CATALOG"; then
    echo "Путь assets/${name}.png уже существует в AssetsCatalog"
    exit 0
fi

tmp_file=$(mktemp)

awk -v new_line="$new_line" '
/^}/ && !inserted {
    print new_line
    inserted = 1
}
{ print }
' "$ASSETS_CATALOG" > "$tmp_file" && mv "$tmp_file" "$ASSETS_CATALOG"

echo "Ассеты перемещены:"
echo "  assets/${name}.png"
echo "  assets/2.0x/${name}.png"
echo "  assets/3.0x/${name}.png"
echo "Добавлена запись в AssetsCatalog:"
echo "$new_line"