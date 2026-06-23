#!/bin/sh
 
if ! firebase help > /dev/null 2>&1; then
    echo Error: Firebase CLI not installed! Open link for install firebase https://firebase.google.com/docs/cli#install_the_firebase_cli
    exit -1
fi

if ! firebase projects:list > /dev/null 2>&1; then
    echo Error: Failed to authenticate, have you run firebase login?
    exit -1
fi

# appId=<Input Firebase App ID here>
appId=1:293893731044:android:0bba1a4c4ea3bdd52c32f1

if [ -z ${appId+x} ]; then
    echo Error: Firebase App ID not found. Input Firebase App ID
    exit -1
fi

if flutter build apk -t lib/main.dart --flavor dev; then
    if firebase appdistribution:distribute build/app/outputs/flutter-apk/app-dev-release.apk --app $appId --groups Base;  then 
        echo "Upload success!"
    else
        open build/app/outputs/flutter-apk
    fi
fi