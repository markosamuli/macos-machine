#!/usr/bin/env bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

MACHINE_REPO=${MACHINE_REPO:-https://github.com/markosamuli/macos-machine.git}
MACHINE=${MACHINE:-$HOME/.machine}

error() {
    echo "$@" 1>&2
}

configure_machine() {
    if [ -e "${DIR}/install.sh" ] && [ ! -d "${MACHINE}" ]; then
        MACHINE="${DIR}"
    fi
}

# Download repository with Git
download_machine() {
    # Do we need to download the machine repository?
    if [ ! -d "${MACHINE}" ]; then
        echo "*** Cloning macos-machine from GitHub..."
        git clone "${MACHINE_REPO}" "${MACHINE}"
    fi
}

# Check that Xcode is installed
setup_xcode() {
    command -v xcode-select 1>/dev/null 2>&1 || {
        error "Xcode is not installed"
        exit 1
    }
}

# Check that Git is installed
setup_git() {
    command -v git 1>/dev/null 2>&1 || {
        error "Git is not installed"
        exit 1
    }
}

# Run setup script
setup_machine() {
    cd "${MACHINE}" || {
        error "${MACHINE} not found"
        exit 1
    }
    ./setup --sudo
}

setup_xcode
setup_git

configure_machine
download_machine
setup_machine
