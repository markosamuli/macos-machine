# Changelog

## [2.0.0] - 2019-11-20

Release with macOS Mojave support.

### Added

* Fix permissions in user home directory
* Install [doctl] from Homebrew
* Install [JetBrains Toolbox]
* Install [p7zip]
* Install [htop]
* Install [asciinema]
* Install [Lua] programming language and custom `luarocks` Ansible module
* Install Vim or MacVim
* Install zsh with Homebrew
* Install [asdf] version manager with [markosamuli.asdf] v1.1.0
* Install GNU sed
* Install GNU tar
* Install [Hammerspoon] automation tool with `ReloadConfiguration.spoon`
* Install [Hazel] automation tool
* Install [rbenv] and [Ruby] with [zzet.rbenv] role
* Install [shellcheck]
* Install [shfmt]

[doctl]: https://github.com/digitalocean/doctl
[JetBrains Toolbox]: https://www.jetbrains.com/toolbox-app/
[p7zip]: http://p7zip.sourceforge.net/
[htop]: https://hisham.hm/htop/
[asciinema]: https://asciinema.org/
[Lua]: https://www.lua.org/
[asdf]: https://asdf-vm.com/
[markosamuli.asdf]: https://github.com/markosamuli/ansible-asdf
[Hammerspoon]: https://www.hammerspoon.org/
[Hazel]: https://www.noodlesoft.com/
[zzet.rbenv]: https://github.com/zzet/ansible-rbenv-role
[rbenv]: https://github.com/rbenv/rbenv
[Ruby]: https://www.ruby-lang.org/en/

### Removed

* Atom editor is no longer installed

### Changed

#### Default installation options

The following tools are no longer installed automatically but require to be
manually enabled:

* Slack desktop application
* Google Drive File Stream
* `nmap`
* `certbot`
* Vagrant and VirtualBox
* Packer

#### Tools

* Use shared setup script with the [linux-machine] repository
* Added `machine.yaml` configuration file for local playbook overrides
  and customizations
* Check Ansible version in the `setup` script and in the Ansible playbook setup
  phase
* Makefile with tasks for common playbooks
* Ansible Galaxy support in `update-roles` script
* Check for outdated Homebrew packages when running `setup`

[linux-machine]: https://github.com/markosamuli/linux-machine

#### Terraform

* Install Terraform with [tfenv]
* Remove conflicting [Terraform] installations including asdf plugin and any
  installed versions
* Removed [markosamuli.terraform] role and previously installed binaries

[tfenv]: https://github.com/tfutils/tfenv
[markosamuli.terraform]: https://github.com/markosamuli/ansible-terraform

#### Golang

* Upgraded [markosamuli.golang] from v1.0.0 to v1.2.0
* Optional shell script initialization
* Install common Go packages with the [markosamuli.golang] role
* Changed default GOPATH from `~/Projects/golang` to `~/go`
* Add `GO111MODULES` environment variable into shell configuration

[markosamuli.golang]: https://github.com/markosamuli/ansible-golang

#### Google Cloud SDK

* Upgraded [markosamuli.gcloud] from v1.1.0 to v2.1.1
* Cloud SDK release 271.0.0
* Changed default installation path from `~/opt/google-cloud-sdk` to
  `~/google-cloud-sdk`

[markosamuli.gcloud]: https://github.com/markosamuli/ansible-gcloud

#### Node.js

* Upgraded [markosamuli.nvm] from v1.1.0 to v1.4.1
* Install NVM v0.35.1
* Install Node.js LTS as the default version
* Load bash completion in shell scripts

[markosamuli.nvm]: https://github.com/markosamuli/ansible-nvm

#### Python

* Upgraded [markosamuli.pyenv] from v1.2.0 to v2.1.1
* Building Python versions now working on macOS Mojave
* Load shell completions from Homebrew directory
* Update to [pyenv 1.2.15]
* Update to [Python 2.7.17]
* Update to [Python 3.7.5]

[markosamuli.pyenv]: https://github.com/markosamuli/ansible-pyenv
[pyenv 1.2.15]: https://github.com/pyenv/pyenv/releases/tag/v1.2.15
[Python 2.7.17]: https://www.python.org/downloads/release/python-2717/
[Python 3.7.5]: https://www.python.org/downloads/release/python-375/

#### Development improvements

* Travis: Run tests with Xcode 11.0
* Travis: Do not test with Xcode 9.4
* Travis: Builds fail faster
* Travis: Run builds on pull requests and main branches only
* GitHub Actions: Added new pre-commit workflow
* Added [markdownlint] pre-commit hook
* Validate shell scripts with [shellcheck] and improve coding style
* Format shell scripts with [shfmt]
* Setup virtualenv with pyenv for local development

[markdownlint]: https://github.com/DavidAnson/markdownlint
[shellcheck]: https://github.com/koalaman/shellcheck
[shfmt]: https://github.com/mvdan/sh

## [1.0.0] - 2019-03-02

Initial version on macOS High Sierra.

[1.0.0]: https://github.com/markosamuli/macos-machine/releases/tag/v1.0.0
