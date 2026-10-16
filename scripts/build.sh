#!/bin/sh
set -eu

VERSION=$(cat VERSION)
mkdir -p dist
echo "app version ${VERSION}" > "dist/app-${VERSION}.txt"
echo "Build de la version ${VERSION} terminé"