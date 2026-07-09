#!/bin/sh
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

copy_if_missing() {
  target="$1"
  example="$2"
  if [ ! -f "$target" ] && [ -f "$example" ]; then
    cp "$example" "$target"
    echo "Created $target from example"
  fi
}

copy_if_missing "$ROOT/.env" "$ROOT/.env.example"
copy_if_missing "$ROOT/env/dev.env.json" "$ROOT/env/dev.env.json.example"
copy_if_missing "$ROOT/env/dev-backend.env.json" "$ROOT/env/dev-backend.env.json.example"
copy_if_missing "$ROOT/env/prod.env.json" "$ROOT/env/prod.env.json.example"
copy_if_missing "$ROOT/secrets/google-services.json" "$ROOT/secrets/google-services.json.example"
copy_if_missing "$ROOT/secrets/GoogleService-Info.plist" "$ROOT/secrets/GoogleService-Info.plist.example"
copy_if_missing "$ROOT/ios/Flutter/Secrets.xcconfig" "$ROOT/ios/Flutter/Secrets.xcconfig.example"

if [ -f "$ROOT/.env" ]; then
  # shellcheck disable=SC1091
  . "$ROOT/.env"
fi

if [ -f "$ROOT/secrets/google-services.json" ]; then
  cp "$ROOT/secrets/google-services.json" "$ROOT/android/app/google-services.json"
  echo "Copied google-services.json → android/app/"
fi

if [ -f "$ROOT/secrets/GoogleService-Info.plist" ]; then
  cp "$ROOT/secrets/GoogleService-Info.plist" "$ROOT/ios/Runner/GoogleService-Info.plist"
  echo "Copied GoogleService-Info.plist → ios/Runner/"
fi

if [ -n "${IOS_DEVELOPMENT_TEAM:-}" ]; then
  printf 'DEVELOPMENT_TEAM = %s\n' "$IOS_DEVELOPMENT_TEAM" > "$ROOT/ios/Flutter/Secrets.xcconfig"
  echo "Updated ios/Flutter/Secrets.xcconfig"
fi

echo "Secrets setup complete."
