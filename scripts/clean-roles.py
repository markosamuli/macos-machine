#!/usr/bin/env python

import yaml
import os
import shutil
import logging

META_INSTALL = os.path.join('meta', '.galaxy_install_info')

if 'DEBUG' in os.environ:
    logging.basicConfig(level=logging.DEBUG)


def list_required_roles():
    """Return Ansible roles from the requirements.yml file"""
    roles = []
    role_file = 'requirements.yml'
    with open(role_file, 'r') as f:
        required_roles = yaml.safe_load(f.read())
        for role in required_roles:
            roles.append(role)
    return sorted(roles, key=lambda role: role['name'])


def list_installed_roles(roles_path):
    """List installed roles and get version from .galaxy_install_info file"""

    roles = []

    path_files = os.listdir(roles_path)
    for path_file in path_files:
        path = os.path.join(roles_path, path_file)

        install_info = None
        info_path = os.path.join(path, META_INSTALL)
        if os.path.isfile(info_path):
            with open(info_path, 'r') as f:
                install_info = yaml.safe_load(f)

        version = None
        if install_info:
            version = install_info['version']

        git = False
        git_path = os.path.join(path, '.git')
        if os.path.exists(git_path):
            git = True

        roles.append({
            'name': os.path.basename(path),
            'version': version,
            'path': path,
            'git': git
        })

    return sorted(roles, key=lambda role: role['name'])


def main():
    """Remove any outdates Ansible roles"""

    required_roles = list_required_roles()
    installed_roles = list_installed_roles("playbooks/roles")

    for required_role in required_roles:

        installed = False
        for installed_role in installed_roles:

            if required_role['name'] != installed_role['name']:
                continue

            installed = True

            role_path = installed_role['path']

            if installed_role['git']:
                logging.debug('role %s in %s is a Git repository',
                              installed_role['name'], role_path)
                break

            if not installed_role['version']:
                logging.debug(
                    'role %s installed %s != required %s'.
                    installed_role['name'], '(unknown version)',
                    required_role['version'])
                break

            if required_role['version'] == installed_role['version']:
                logging.debug('role %s installed %s', installed_role['name'],
                              installed_role['version'])
                break

            logging.info('role %s installed %s != required %s',
                         installed_role['name'], installed_role['version'],
                         required_role['version'])

            if os.path.isdir(role_path):
                print('Remove outdated %s' % installed_role['name'])
                logging.info("remove role %s in %s", installed_role['name'],
                             role_path)
                shutil.rmtree(role_path)
            else:
                logging.warning("Role %s not found in %s",
                                installed_role['name'], role_path)

            break

        if not installed:
            logging.debug('role %s not installed', required_role['name'])


if __name__ == '__main__':
    main()
