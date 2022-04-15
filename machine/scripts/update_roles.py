#!/usr/bin/env python3
"""Update Ansible roles in requirements.yml to their latest released version"""

import sys
from machine.roles import get_updated_role  # noqa: E402
from machine.roles import list_required_roles  # noqa: E402
from machine.roles import update_required_roles  # noqa: E402

# pylint: disable=unused-import
import machine.config  # noqa: E402,F401

# pylint: enable=unused-import


def update_roles():
    """Update role versions in the requirements.yml"""

    roles = list_required_roles()

    roles_updated = 0
    updated_roles = []

    for role in roles:
        updated_role = get_updated_role(role)
        if updated_role and updated_role["version"] != role["version"]:
            print(
                f'update {role["name"]}: {role["version"]} -> {updated_role["version"]}'
            )
            roles_updated += 1
            updated_roles.append(updated_role)
        else:
            updated_roles.append(role)

    if roles_updated > 0:
        if len(roles) > len(updated_roles):
            print("update failed: roles missing from updated roles list")
            sys.exit(1)

        update_required_roles(updated_roles)


if __name__ == "__main__":
    update_roles()
