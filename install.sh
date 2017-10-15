#!/usr/bin/env bash

MACHINE_REPO=https://github.com/markosamuli/macos-machine.git
MACHINE=$HOME/.machine

function download_machine {
    # Do we need to download the machine repository?
    if [ ! -d "$MACHINE" ]; then
        echo "*** Cloning macos-machine from GitHub..."
        git clone $MACHINE_REPO $MACHINE
    fi
}

function setup_xcode {
    command -v xcode-select 1>/dev/null 2>&1 || {
        echo "Xcode is not installed."
        exit 1
    }
}

function setup_machine {
    cd $MACHINE
    ./setup
}

# Clone repository
download_machine

# Xcode setup
setup_xcode

# Run setup
setup_machine