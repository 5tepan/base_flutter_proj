#!/bin/sh

# Добавление локальных ассетов в проект:
#   1) SVG — один файл → assets/icons/ + AppAssets (vector)
#   2) PNG — 1x, @2x, @3x из корня → assets/ + AppAssets (raster)
#
# Запуск: make toAssets  (из корня репозитория)

set -e

ASSETS_CATALOG="lib/core/assets/app_assets.dart"
ICONS_DIR="assets/icons"

# ic_shopping_cart → shoppingCart; placeholder → placeholder
to_const_name() {
  name="$1"
  case "$name" in
    ic_*) name="${name#ic_}" ;;
  esac
  echo "$name" | awk -F '_' '{
    for (i = 1; i <= NF; i++) {
      if (i == 1) {
        printf "%s", tolower($i)
      } else {
        printf "%s%s", toupper(substr($i, 1, 1)), tolower(substr($i, 2))
      }
    }
  }'
}

asset_exists() {
  const_name="$1"
  asset_path="$2"
  if grep -q "static const ${const_name} =" "$ASSETS_CATALOG" 2>/dev/null; then
    return 0
  fi
  if grep -Fq "$asset_path" "$ASSETS_CATALOG" 2>/dev/null; then
    return 0
  fi
  return 1
}

insert_vector_entry() {
  new_line="$1"
  tmp_file=$(mktemp)
  awk -v new_line="$new_line" '
    /^[[:space:]]*\/\/ --- Raster \(PNG\) ---/ && !inserted {
      print new_line
      inserted = 1
    }
    { print }
    END {
      if (!inserted) {
        exit 1
      }
    }
  ' "$ASSETS_CATALOG" > "$tmp_file" || {
    rm -f "$tmp_file"
    echo "Не найден маркер «// --- Raster (PNG) ---» в $ASSETS_CATALOG"
    exit 1
  }
  mv "$tmp_file" "$ASSETS_CATALOG"
}

insert_raster_entry() {
  new_line="$1"
  tmp_file=$(mktemp)
  awk -v new_line="$new_line" '
    /^[[:space:]]*\/\/\/ Ассеты для предзагрузки/ && !inserted {
      print new_line
      inserted = 1
    }
    { print }
    END {
      if (!inserted) {
        exit 1
      }
    }
  ' "$ASSETS_CATALOG" > "$tmp_file" || {
    rm -f "$tmp_file"
    echo "Не найден маркер preloadable в $ASSETS_CATALOG"
    exit 1
  }
  mv "$tmp_file" "$ASSETS_CATALOG"
}

add_svg_asset() {
  printf "Имя SVG в assets/icons (например ic_my_icon, без .svg): "
  read -r name

  if [ -z "$name" ]; then
    echo "Некорректное имя ассета"
    exit 1
  fi

  case "$name" in
    *.svg)
      name="${name%.svg}"
      ;;
  esac

  source_file=""
  if [ -f "./${name}.svg" ]; then
    source_file="./${name}.svg"
  else
    svg_count=$(find . -maxdepth 1 -name '*.svg' 2>/dev/null | wc -l | tr -d ' ')
    if [ "$svg_count" = "1" ]; then
      source_file=$(find . -maxdepth 1 -name '*.svg' | head -n 1)
      echo "Найден файл в корне: $(basename "$source_file")"
    fi
  fi

  if [ -z "$source_file" ] || [ ! -f "$source_file" ]; then
    echo "Положите ${name}.svg в корень проекта (рядом с pubspec.yaml) и запустите снова."
    exit 1
  fi

  mkdir -p "$ICONS_DIR"
  dest_file="${ICONS_DIR}/${name}.svg"

  if [ -f "$dest_file" ]; then
    printf "Файл %s уже существует. Перезаписать? [y/N]: " "$dest_file"
    read -r overwrite
    case "$overwrite" in
      y|Y|yes|YES) ;;
      *) echo "Отменено."; exit 0 ;;
    esac
  fi

  mv "$source_file" "$dest_file"

  const_name=$(to_const_name "$name")
  dart_path="\$_icons/${name}.svg"
  new_line="  static const ${const_name} = AppAsset('${dart_path}', AppAsset.vector);"

  if [ ! -f "$ASSETS_CATALOG" ]; then
    echo "Файл $ASSETS_CATALOG не найден"
    exit 1
  fi

  if asset_exists "$const_name" "$dart_path"; then
    echo "Запись для ${const_name} уже есть в AppAssets (файл перемещён)."
    exit 0
  fi

  insert_vector_entry "$new_line"

  echo ""
  echo "SVG добавлен:"
  echo "  ${dest_file}"
  echo "Запись в AppAssets:"
  echo "  ${new_line}"
  echo ""
  echo "Использование: AppIcon(AppAssets.${const_name})"
}

add_png_asset() {
  printf "Имя PNG в assets (например ic_logo или placeholder, без .png): "
  read -r name

  if [ -z "$name" ]; then
    echo "Некорректное имя ассета"
    exit 1
  fi

  case "$name" in
    *.png)
      name="${name%.png}"
      ;;
  esac

  filename=$(find . -maxdepth 1 -name '*@3x.png' 2>/dev/null | head -n 1 | xargs -n 1 basename 2>/dev/null | sed 's/@3x\.png$//')

  if [ -z "$filename" ]; then
    echo "Не найден файл вида *@3x.png в корне проекта"
    echo "Ожидаются: name.png, name@2x.png, name@3x.png"
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

  for target in "assets/${name}.png" "assets/2.0x/${name}.png" "assets/3.0x/${name}.png"; do
    if [ -f "$target" ]; then
      printf "Файл %s уже существует. Перезаписать? [y/N]: " "$target"
      read -r overwrite
      case "$overwrite" in
        y|Y|yes|YES) ;;
        *)
          echo "Отменено."
          exit 0
          ;;
      esac
      break
    fi
  done

  mv "./${filename}.png" "assets/${name}.png"
  mv "./${filename}@2x.png" "assets/2.0x/${name}.png"
  mv "./${filename}@3x.png" "assets/3.0x/${name}.png"

  const_name=$(to_const_name "$name")
  dart_path="assets/${name}.png"
  new_line="  static const ${const_name} = AppAsset('${dart_path}', AppAsset.raster);"

  if [ ! -f "$ASSETS_CATALOG" ]; then
    echo "Файл $ASSETS_CATALOG не найден"
    exit 1
  fi

  if asset_exists "$const_name" "$dart_path"; then
    echo "Запись для ${const_name} уже есть в AppAssets (файлы перемещены)."
    exit 0
  fi

  insert_raster_entry "$new_line"

  echo ""
  echo "PNG добавлены:"
  echo "  assets/${name}.png"
  echo "  assets/2.0x/${name}.png"
  echo "  assets/3.0x/${name}.png"
  echo "Запись в AppAssets:"
  echo "  ${new_line}"
  echo ""
  echo "Использование: AppIcon(AppAssets.${const_name})"
}

if [ ! -f "$ASSETS_CATALOG" ]; then
  echo "Запускайте из корня проекта: make toAssets"
  exit 1
fi

echo "Добавление ассета в AppAssets"
echo "  1) SVG — один файл (иконка UI)"
echo "  2) PNG — три плотности 1x / 2x / 3x (логотип, иллюстрация)"
printf "Выберите тип [1/2]: "
read -r asset_type

case "$asset_type" in
  1|svg|SVG)
    add_svg_asset
    ;;
  2|png|PNG)
    add_png_asset
    ;;
  *)
    echo "Неверный выбор. Укажите 1 или 2."
    exit 1
    ;;
esac
