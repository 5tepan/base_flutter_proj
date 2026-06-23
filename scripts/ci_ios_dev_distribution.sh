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
appId=1:293893731044:ios:827ea9f2751bf9442c32f1

if [ -z ${appId+x} ]; then
    echo Error: Firebase App ID not found. Input Firebase App ID
    exit -1
fi

FILE=Dev_ExportOptions.plist
if [ ! -f "$FILE" ]; then
    echo "Warning: $FILE does not exist. Сommand 'firebase appdistribution:distribute' will not be executed. Export the IPA archive manually and copy the file ExportOptions.plist to Dev_ExportOptions.plist"
    flutter build ipa -t lib/main.dart --flavor dev
else
    if flutter build ipa -t lib/main.dart --flavor dev --export-options-plist Dev_ExportOptions.plist;  then 
        ios/Pods/FirebaseCrashlytics/upload-symbols -gsp ios/Runner/GoogleService-Info.plist -p ios build/ios/archive/Runner.xcarchive/dSYMs
        if firebase appdistribution:distribute build/ios/ipa/base_flutter_proj.ipa --app $appId --groups Base;  then 
            echo "Upload success!"
        else
            open build/ios/ipa
        fi
    fi
fi 