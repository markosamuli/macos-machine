#!/usr/bin/env python3
"""Remove Ansible roles that don't meet the current version as defined
in requirements.yml file"""

import sys
from pathlib import Path

# Add project root to to sys.path
FILE = Path(__file__).resolve()
SCRIPTS_DIR, PROJECT_ROOT = FILE.parent, FILE.parents[1]
sys.path.append(str(PROJECT_ROOT))
# Remove the current scripts/ directory from sys.path
try:
    sys.path.remove(str(SCRIPTS_DIR))
except ValueError:  # Already removed
    pass

# pylint: disable=wrong-import-position
from machine.roles import remove_outdated_roles  # noqa: E402

# pylint: disable=unused-import
import machine.config  # noqa: E402,F401

# pylint: enable=unused-import
# pylint: enable=wrong-import-position

MACHINE_ROLES_PATH = "playbooks/roles"


def clean_roles():
    """Remove any outdates Ansible roles"""

    removed_roles = remove_outdated_roles(MACHINE_ROLES_PATH)
    for removed_role in removed_roles:
        print("Removed outdated role %s" % removed_role["name"])


if __name__ == "__main__":
    clean_roles()
