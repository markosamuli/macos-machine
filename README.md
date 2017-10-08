Development macOS Setup
=======================

This is a collection of Ansible roles and tasks to setup a new developer machine as described on the Beyond Development setup on macOS documentation.

This setup has only been tested on the macOS Sierra and not against existing installations.

Requirements
------------

- OS X 10.10 or higher
- Xcode installed

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
