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

# Python version to use for the virtualenv
PYTHON_VERSION=$(pyenv install --list | sed 's/ //g' | grep "^3\.7\.[0-9]*\$" | sort -r | head -1)
if [ -z "${PYTHON_VERSION}" ]; then
    error "Python 3.7 versions are not installed"
    exit 1
fi
PYTHON_VERSION_PATH="${HOME}/.pyenv/versions/${PYTHON_VERSION}"

# Virtualenv name will be generated from the repository name
PYENV_VIRTUALENV=$(basename "$(pwd)")
PYENV_VIRTUALENV_PATH="${HOME}/.pyenv/versions/${PYENV_VIRTUALENV}"

# Get local pyenv version
PYENV_LOCAL=$(pyenv local 2>/dev/null)

if [ -z "${PYENV_LOCAL}" ]; then
    # Local version is not defined
    # 1. Install Python if missing
    if [ ! -d "${PYTHON_VERSION_PATH}" ]; then
        echo "Install Python ${PYTHON_VERSION}"
        pyenv install "${PYTHON_VERSION}" || {
            error "Failed to install Python version"
            exit 1
        }
    fi

    # 2. Create virtualenv if missing
    if [ ! -d "${PYENV_VIRTUALENV_PATH}" ]; then
        echo "Creating virtualenv '${PYENV_VIRTUALENV}' with pyenv using Python ${PYTHON_VERSION}"
        pyenv virtualenv "${PYTHON_VERSION}" "${PYENV_VIRTUALENV}" || {
            error "Failed to create new virtualenv"
            exit 1
        }
    fi

    # 3. Set local virtualenv
    echo "Using virtualenv '${PYENV_VIRTUALENV}'"
    pyenv local "${PYENV_VIRTUALENV}" || {
        error "Failed to set local virtualenv"
        exit 1
    }

    # Upgrade pip
    pyenv exec pip install --upgrade pip

    # Get local pyenv version
    PYENV_LOCAL=$(pyenv local 2>/dev/null)
fi

# Local version is set
if [ "${PYENV_LOCAL}" != "${PYENV_VIRTUALENV}" ]; then
    echo "WARNING: pyenv local version should be ${PYENV_VIRTUALENV}, found ${PYENV_LOCAL}"
fi
