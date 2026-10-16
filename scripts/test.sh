#!/bin/sh
set -eu

VERSION=$(cat VERSION)

echo "${VERSION}" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$' || {
    echo "ECHEC : version invalide : ${VERSION}"
    exit 1
}

test -f "dist/app-${VERSION}.txt" || {
    echo "ECHEC : artefact introuvable"
    exit 1
}

echo "Tests réussis (version ${VERSION})"