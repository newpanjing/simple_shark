#!/usr/bin/env bash
mkdir -p docs
rm -rf docs/*
flutter build web --release --web-renderer html --no-sound-null-safety
cp -r ./build/web/* ./docs/
git add docs/
git commit -m "Update docs"
git push