#!/usr/bin/env python3
"""Remove Ansible roles that don't meet the current version as defined
in requirements.yml file"""

from machine.roles import remove_outdated_roles

# pylint: disable=unused-import
import machine.config  # noqa: E402,F401

# pylint: enable=unused-import

MACHINE_ROLES_PATH = "playbooks/roles"


def clean_roles():
    """Remove any outdates Ansible roles"""

    removed_roles = remove_outdated_roles(MACHINE_ROLES_PATH)
    for removed_role in removed_roles:
        print(f'Removed outdated role {removed_role["name"]}')


if __name__ == "__main__":
    clean_roles()
