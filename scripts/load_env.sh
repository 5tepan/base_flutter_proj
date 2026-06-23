#!/bin/sh
# Подключает .env в shell-скриптах: . "$(dirname "$0")/load_env.sh"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if [ -f "$ROOT/.env" ]; then
  # shellcheck disable=SC1091
  . "$ROOT/.env"
fi
