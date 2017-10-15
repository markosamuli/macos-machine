Development macOS Setup
=======================

[![Build Status](https://travis-ci.org/markosamuli/macos-machine.svg?branch=master)](https://travis-ci.org/markosamuli/macos-machine)

This is a collection of Ansible roles and tasks to setup a new developer machine on macOS.

This setup has only been tested on the macOS Sierra and not against existing installations.

Requirements
------------

- OS X 10.10 or higher
- Xcode installed
- Git installed

Install
-------

You can run the installer script that will clone the code from GitHub and run the `setup` script.

```
curl -s https://raw.githubusercontent.com/markosamuli/macos-machine/master/install.sh | bash -
```

Getting Started
---------------

Clone this project locally and run the `./setup` script.

```bash
git clone https://github.com/markosamuli/macos-machine
cd macos-machine
./setup
```

Ansible Roles
-------------

The following external Ansible roles are installed and used:

- [markosamuli.terraform](https://github.com/markosamuli/ansible-terraform)
- [markosamuli.packer](https://github.com/markosamuli/ansible-packer)
- [markosamuli.aws-tools](https://github.com/markosamuli/ansible-aws-tools)
- [markosamuli.cloud](https://github.com/markosamuli/ansible-cloud)
- [markosamuli.nvm](https://github.com/markosamuli/ansible-nvm)
- [markosamuli.vagrant](https://github.com/markosamuli/ansible-vagrant)

License
-------

MIT

Authors
-------

- [@markosamuli](https://github.com/markosamuli)
