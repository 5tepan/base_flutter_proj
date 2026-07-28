#!/usr/bin/env sh
# yandex_maps_mapkit_lite ships a broken Package.swift (`exact: ""`),
# which breaks Xcode SPM resolution. The plugin also has a working podspec,
# so we hide Package.swift and let Flutter fall back to CocoaPods for MapKit
# while the rest of the project uses Swift Package Manager.
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"
CACHE="${PUB_CACHE:-$HOME/.pub-cache}/hosted/pub.dev"

found=0
for dir in "$CACHE"/yandex_maps_mapkit_lite-*; do
  [ -d "$dir" ] || continue
  pkg="$dir/ios/yandex_maps_mapkit_lite/Package.swift"
  if [ -f "$pkg" ]; then
    mv "$pkg" "$pkg.disabled"
    echo "Disabled SPM manifest: $pkg"
    found=1
  elif [ -f "$pkg.disabled" ]; then
    echo "Already disabled: $pkg.disabled"
    found=1
  fi
done

ephemeral="$ROOT/ios/Flutter/ephemeral/Packages/.packages"
if [ -d "$ephemeral" ]; then
  for dir in "$ephemeral"/yandex_maps_mapkit_lite-*; do
    [ -d "$dir" ] || continue
    pkg="$dir/Package.swift"
    if [ -f "$pkg" ]; then
      mv "$pkg" "$pkg.disabled"
      echo "Disabled ephemeral SPM manifest: $pkg"
      found=1
    fi
  done
fi

if [ "$found" -eq 0 ]; then
  echo "yandex_maps_mapkit_lite not found in pub-cache; run flutter pub get first." >&2
  exit 1
fi
