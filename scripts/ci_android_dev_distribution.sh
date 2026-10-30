#!/bin/sh

. "$(dirname "$0")/load_env.sh"

if ! firebase help > /dev/null 2>&1; then
    echo Error: Firebase CLI not installed! Open link for install firebase https://firebase.google.com/docs/cli#install_the_firebase_cli
    exit -1
fi

if ! firebase projects:list > /dev/null 2>&1; then
    echo Error: Failed to authenticate, have you run firebase login?
    exit -1
fi

# Задайте FIREBASE_ANDROID_APP_ID в .env
appId="${FIREBASE_ANDROID_APP_ID:-}"

if [ -z "$appId" ]; then
    echo "Error: FIREBASE_ANDROID_APP_ID not set. Add it to .env (see .env.example)"
    exit 1
fi

# Release для дистрибуции нельзя подписывать debug-ключом.
keystore_props="android/key.properties"
if [ ! -f "$keystore_props" ]; then
    echo "Error: $keystore_props is missing. Copy android/key.properties.example and point storeFile at the upload keystore."
    exit 1
fi

store_file=$(sed -n 's/^storeFile=//p' "$keystore_props" | head -n 1)
if [ -z "$store_file" ]; then
    echo "Error: storeFile is empty in $keystore_props"
    exit 1
fi

if [ ! -f "android/app/$store_file" ] && [ ! -f "$store_file" ]; then
    echo "Error: keystore file not found ($store_file). Release distribution refuses the debug signing key."
    exit 1
fi

if flutter build apk -t lib/main.dart --flavor dev --dart-define-from-file=env/dev.env.json; then
    if firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-release.apk --app $appId --groups Base;  then 
        echo "Upload success!"
    else
        open build/app/outputs/flutter-apk
    fi
fi