#!/usr/bin/env bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_ROOT=$(dirname "$DIR")

# Print error into STDERR
error() {
    echo "$@" 1>&2
}

install_travis=0
if command -v travis >/dev/null; then
    travis_version=$(travis --version)
    if [ -z "${travis_version}" ]; then
        install_travis=1
    fi
else
    install_travis=1
fi

if [ "${install_travis}" -eq "1" ]; then
    command -v gem || {
        error "gem command not found"
        exit 1
    }
    gem install travis || {
        error "Couldn't install travis CLI"
        exit 1
    }
fi

cd "${PROJECT_ROOT}" || {
    error "Couldn't find ${PROJECT_ROOT}"
    exit 1
}

for file in "$@"; do
    travis lint -x "${file}"
done
