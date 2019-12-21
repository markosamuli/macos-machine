# Changelog

## [2.1.0] - 2019-11-24

### Added

#### Rust

- Install [Rust][rust] programming language with [markosamuli.rust]

[rust]: https://www.rust-lang.org/
[markosamuli.rust]: https://github.com/markosamuli/ansible-rust

### Fixed

- Use `bash` executable instead of `sh` with Ansible on WSL environments to get
  around Windows directory white spaces on the PATH. Fixes issues with
  `zzet.rbenv` role no longer using bash for executing shell commands.
- Fix `update-roles.py` script not working if using master as version in
  `requirements.yml` file.

### Changed

#### Ansible

- Require minimum Ansible version 2.7
- Install Ansible 2.8 as the default version
- Check that we're not using broken Ansible v2.8.6

#### Setup script

- Rework on the setup script for improved Ansible installation when using
  `pyenv` or `virtualenv` or calling Ansible with any non-system paths.
- Support for installing Ansible in a local virtualenv from PyPI.
- Allow setting the default Ansible version with `MACHINE_ANSIBLE_VERSION`
  environment variable.
- Added support for uninstalling existing Ansible installations.
- Added new long command line options in the setup script.

#### Makefile

- Self-documented Makefile and `make help` command.
- Added `setup` command for running `setup` script with the default options.
- Added `install-ansible` Makefile command that doesn't enable or disable PyPI
  and doesn't reinstall existing Ansible installations.
- Renamed `roles` Makefile command to `install-roles` and removed `-f` argument.
- Renamed `update` Makefile command to `update-roles`.
- Added `clean-roles` Makefile command for running `clean_roles.py` script.
- Added `latest-roles` Makefile command to update, clean and install required
  Ansible roles to their latest versions.

#### Google Cloud SDK

- Upgraded [markosamuli.gcloud] from v2.1.1 to v2.1.2
- Cloud SDK release 271.0.0
- Option for preferring `python3` over `python2` during install

#### AWS tools

- Upgraded [markosamuli.aws_tools] from v1.0.1 to v2.1.0

[markosamuli.aws_tools]: https://github.com/markosamuli/ansible-aws-tools

#### Python scripts

- Moved Python business logic and shared functionality from the Python scripts
  into a local `machine` Python package.

#### Development and coding style improvements

- Minimum `pre-commit` version 1.20
- Removed `autopep8` in favour of using `yapf` for formatting Python code
- Added `pylint` pre-commit hooks for linting Python code
- Move development requirements into `requirements.dev.txt` file
- Use more strict `yamllint` rules and format files according

#### Travis

- Do not run builds with Xcode 10.2.1 on macOS 10.14.

## [2.0.0] - 2019-11-20

Release with macOS Mojave support.

### Added

- Fix permissions in user home directory
- Install [doctl] from Homebrew
- Install [JetBrains Toolbox][jetbrains-toolbox]
- Install [p7zip]
- Install [htop]
- Install [asciinema]
- Install [Lua][lua] programming language and custom `luarocks` Ansible module
- Install Vim or MacVim
- Install zsh with Homebrew
- Install [asdf] version manager with [markosamuli.asdf] v1.1.0
- Install GNU sed
- Install GNU tar
- Install [Hammerspoon][hammerspoon] automation tool with
  `ReloadConfiguration.spoon`
- Install [Hazel][hazel] automation tool
- Install [rbenv] and [Ruby][ruby] with [zzet.rbenv] role
- Install [shellcheck]
- Install [shfmt]

[doctl]: https://github.com/digitalocean/doctl
[jetbrains-toolbox]: https://www.jetbrains.com/toolbox-app/
[p7zip]: http://p7zip.sourceforge.net/
[htop]: https://hisham.hm/htop/
[asciinema]: https://asciinema.org/
[lua]: https://www.lua.org/
[asdf]: https://asdf-vm.com/
[markosamuli.asdf]: https://github.com/markosamuli/ansible-asdf
[hammerspoon]: https://www.hammerspoon.org/
[hazel]: https://www.noodlesoft.com/
[zzet.rbenv]: https://github.com/zzet/ansible-rbenv-role
[rbenv]: https://github.com/rbenv/rbenv
[ruby]: https://www.ruby-lang.org/en/

### Removed

- Atom editor is no longer installed

### Changed

#### Default installation options

The following tools are no longer installed automatically but require to be
manually enabled:

- Slack desktop application
- Google Drive File Stream
- `nmap`
- `certbot`
- Vagrant and VirtualBox
- Packer

#### Tools

- Use shared setup script with the [linux-machine] repository
- Added `machine.yaml` configuration file for local playbook overrides and
  customizations
- Check Ansible version in the `setup` script and in the Ansible playbook setup
  phase
- Makefile with tasks for common playbooks
- Ansible Galaxy support in `update-roles` script
- Check for outdated Homebrew packages when running `setup`

[linux-machine]: https://github.com/markosamuli/linux-machine

#### Terraform

- Install Terraform with [tfenv]
- Remove conflicting [Terraform] installations including asdf plugin and any
  installed versions
- Removed [markosamuli.terraform] role and previously installed binaries

[tfenv]: https://github.com/tfutils/tfenv
[markosamuli.terraform]: https://github.com/markosamuli/ansible-terraform

#### Golang

- Upgraded [markosamuli.golang] from v1.0.0 to v1.2.0
- Optional shell script initialization
- Install common Go packages with the [markosamuli.golang] role
- Changed default GOPATH from `~/Projects/golang` to `~/go`
- Add `GO111MODULES` environment variable into shell configuration

[markosamuli.golang]: https://github.com/markosamuli/ansible-golang

#### Google Cloud SDK

- Upgraded [markosamuli.gcloud] from v1.1.0 to v2.1.1
- Cloud SDK release 271.0.0
- Changed default installation path from `~/opt/google-cloud-sdk` to
  `~/google-cloud-sdk`

[markosamuli.gcloud]: https://github.com/markosamuli/ansible-gcloud

#### Node.js

- Upgraded [markosamuli.nvm] from v1.1.0 to v1.4.1
- Install NVM v0.35.1
- Install Node.js LTS as the default version
- Load bash completion in shell scripts

[markosamuli.nvm]: https://github.com/markosamuli/ansible-nvm

#### Python

- Upgraded [markosamuli.pyenv] from v1.2.0 to v2.1.1
- Building Python versions now working on macOS Mojave
- Load shell completions from Homebrew directory
- Update to [pyenv 1.2.15][pyenv-1.2.15]
- Update to [Python 2.7.17][python-2.7.17]
- Update to [Python 3.7.5][python-3.7.5]

[markosamuli.pyenv]: https://github.com/markosamuli/ansible-pyenv
[pyenv-1.2.15]: https://github.com/pyenv/pyenv/releases/tag/v1.2.15
[python-2.7.17]: https://www.python.org/downloads/release/python-2717/
[python-3.7.5]: https://www.python.org/downloads/release/python-375/

#### Development improvements

- Travis: Run tests with Xcode 11.0
- Travis: Do not test with Xcode 9.4
- Travis: Builds fail faster
- Travis: Run builds on pull requests and main branches only
- GitHub Actions: Added new pre-commit workflow
- Added [markdownlint] pre-commit hook
- Validate shell scripts with [shellcheck] and improve coding style
- Format shell scripts with [shfmt]
- Setup virtualenv with pyenv for local development

[markdownlint]: https://github.com/DavidAnson/markdownlint
[shellcheck]: https://github.com/koalaman/shellcheck
[shfmt]: https://github.com/mvdan/sh

## [1.0.0] - 2019-03-02

Initial version on macOS High Sierra.

[2.1.0]: https://github.com/markosamuli/macos-machine/releases/tag/v2.1.0
[2.0.0]: https://github.com/markosamuli/macos-machine/releases/tag/v2.0.0
[1.0.0]: https://github.com/markosamuli/macos-machine/releases/tag/v1.0.0
