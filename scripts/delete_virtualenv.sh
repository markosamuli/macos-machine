#!/usr/bin/env bash

# Print error into STDERR
error() {
    echo "$@" 1>&2
}

# Get paths to pyenv and Python commmands
PYENV_BIN=$(command -v pyenv 2>/dev/null)

if [ -z "$PYENV_BIN" ]; then
    error "pyenv is not installed"
    exit 1
fi

# Virtualenv name will be generated from the repository name
PYENV_VIRTUALENV=$(basename "$(pwd)")
PYENV_VIRTUALENV_PATH="${HOME}/.pyenv/versions/${PYENV_VIRTUALENV}"

if [ -e ".python-version" ]; then
    rm .python-version
fi

if [ -d "${PYENV_VIRTUALENV_PATH}" ]; then
    pyenv virtualenv-delete "${PYENV_VIRTUALENV}"
fi
