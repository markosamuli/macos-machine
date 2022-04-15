#!/usr/bin/env python3
"""Configure local settings"""

import sys
from machine import settings  # noqa: E402

# pylint: disable=unused-import
import machine.config  # noqa: E402,F401

# pylint: enable=unused-import


def display_usage(command):
    """Display usage help"""
    print(f"Usage: {command} [option] [value]")
    sys.exit(1)


def display_option(name):
    """Display current option value"""
    value = settings.get_option(name)
    print(f"{name}: {value}")


def update_option(name, new_value):
    """Update option value"""
    value = settings.get_option(name)
    if new_value in settings.TRUTHY:
        if not value:
            settings.enable_option(name)
            print(f"{name} is now enabled")
    elif new_value in settings.FALSY:
        if value:
            settings.disable_option(name)
            print(f"{name} is now disabled")
    else:
        if value != new_value:
            value = settings.set_option(name, new_value)
            print(f"{name}: {value}")


if __name__ == "__main__":
    if len(sys.argv) == 3:
        update_option(sys.argv[1], sys.argv[2])
    elif len(sys.argv) == 2:
        display_option(sys.argv[1])
    else:
        display_usage(sys.argv[0])
