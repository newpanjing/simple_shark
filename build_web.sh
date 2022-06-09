#!/usr/bin/env bash
mkdir -p dist
rm -rf dist/*
flutter build web --release --web-renderer html --no-sound-null-safety
cp -r ./build/web/* ./dist/
git add dist/
git commit -m "Update dist"
git push