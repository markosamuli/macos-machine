"""Ansible role functionality"""

import copy
import logging
import os
import shutil
from typing import Any

import yaml  # pylint: disable=import-error

from machine.github import get_latest_version

try:
    from StringIO import StringIO
except ImportError:
    from io import StringIO

REQUIREMENTS_FILE = "requirements.yml"
META_INSTALL = os.path.join("meta", ".galaxy_install_info")


def remove_outdated_roles(roles_path):
    """Remove any outdated Ansible roles"""

    removed_roles = []
    required_roles = list_required_roles()
    installed_roles = list_installed_roles(roles_path)

    for required_role in required_roles:

        installed = False
        for installed_role in installed_roles:

            if required_role["name"] != installed_role["name"]:
                continue

            installed = True

            role_path = installed_role["path"]

            if installed_role["git"]:
                logging.debug(
                    "role %s in %s is a Git repository",
                    installed_role["name"],
                    role_path,
                )
                break

            if not installed_role["version"]:
                logging.debug(
                    "role %s installed %s != required %s",
                    installed_role["name"],
                    "(unknown version)",
                    required_role["version"],
                )
                break

            if required_role["version"] == installed_role["version"]:
                logging.debug(
                    "role %s installed %s",
                    installed_role["name"],
                    installed_role["version"],
                )
                break

            logging.info(
                "role %s installed %s != required %s",
                installed_role["name"],
                installed_role["version"],
                required_role["version"],
            )

            if os.path.isdir(role_path):
                logging.info("remove role %s in %s", installed_role["name"], role_path)
                shutil.rmtree(role_path)
                removed_roles.append(installed_role)
            else:
                logging.warning(
                    "Role %s not found in %s", installed_role["name"], role_path
                )

            break

        if not installed:
            logging.debug("role %s not installed", required_role["name"])

    return removed_roles


def update_required_roles(roles: list[dict[str, Any]]):
    """Update roles in the requirements.yml file"""

    collections: list[dict[str, Any]] = []

    with open(REQUIREMENTS_FILE, "r", encoding="UTF-8") as req_fp:
        requirements = yaml.safe_load(req_fp.read())
        if "collections" in requirements:
            # pylint: disable=invalid-name
            for c in requirements["collections"]:
                collections.append(c)

    output = StringIO()
    requirements = dict(roles=roles, collections=collections)
    yaml.safe_dump(requirements, output, default_flow_style=False, indent=2)

    with open(REQUIREMENTS_FILE, "w+", encoding="UTF-8") as req_fp:
        req_fp.write("---\n")
        req_fp.write(output.getvalue())

    output.close()


def list_required_roles():
    """Return Ansible roles from the requirements.yml file"""
    roles = []
    role_file = REQUIREMENTS_FILE
    with open(role_file, "r", encoding="UTF-8") as req_fp:
        requirements = yaml.safe_load(req_fp.read())
        # pylint: disable=invalid-name
        if "roles" in requirements:
            for r in requirements["roles"]:
                roles.append(r)
        else:
            for r in requirements:
                roles.append(r)
    return sorted(roles, key=lambda role: role["name"])


def list_installed_roles(roles_path):
    """List installed roles and get version from .galaxy_install_info file"""

    roles = []

    path_files = os.listdir(roles_path)
    for path_file in path_files:
        path = os.path.join(roles_path, path_file)

        install_info = None
        info_path = os.path.join(path, META_INSTALL)
        if os.path.isfile(info_path):
            with open(info_path, "r", encoding="UTF-8") as info_fp:
                install_info = yaml.safe_load(info_fp)

        version = None
        if install_info:
            version = install_info["version"]

        git = False
        git_path = os.path.join(path, ".git")
        if os.path.exists(git_path):
            git = True

        roles.append(
            {
                "name": os.path.basename(path),
                "version": version,
                "path": path,
                "git": git,
            }
        )

    return sorted(roles, key=lambda role: role["name"])


def get_updated_role(role):
    """Get updated version for a role"""

    if role["version"] in ["master", "develop"]:
        logging.info(
            "Role %s version is %s branch, not updating version",
            role["name"],
            role["version"],
        )
        return role

    repository = None
    if role["name"] == "zzet.rbenv":
        repository = "zzet/ansible-rbenv-role"
    elif "src" in role:
        repository = role["src"].replace("https://github.com/", "")
    else:
        (galaxy_user, galaxy_role) = role["name"].split(".")
        if galaxy_user in ["markosamuli", "elliotweiser"]:
            repository = f"{galaxy_user}/ansible-{galaxy_role}"

    if not repository:
        logging.warning("Could not find repository for role %s", role["name"])
        return role

    # Ansible role names require underscores but my repositories use dashes
    if "markosamuli" in repository:
        repository = repository.replace("_", "-")

    latest_version = get_latest_version(repository)
    if not latest_version:
        logging.warning("Could not get latest version for role %s", role["name"])
        return role

    if latest_version == role["version"]:
        return role

    updated_role = copy.copy(role)
    updated_role["version"] = latest_version
    return updated_role
