# Development macOS Setup

| Branch  | Status |
|---------|--------|
| master  | [![Build Status](https://travis-ci.org/markosamuli/macos-machine.svg?branch=master)](https://travis-ci.org/markosamuli/macos-machine)
| develop | [![Build Status](https://travis-ci.org/markosamuli/macos-machine.svg?branch=develop)](https://travis-ci.org/markosamuli/macos-machine)

This is a collection of Ansible roles and tasks to setup a new developer machine
on macOS.

Read my [Machine Setup Guide][machine-setup-guide] for instructions.

[machine-setup-guide]: https://machine.msk.io/

## Requirements

- Mac running macOS 10.13 (High Sierra) or later
- Xcode 10.1 or later installed
- Git installed

This setup has only been tested on the macOS Sierra and not against existing
installations.

See [markosamuli/linux-machine] for my Ubuntu Linux setup.

[markosamuli/linux-machine]: https://github.com/markosamuli/linux-machine

## Install

You can run the installer script that will clone the code from GitHub and run
the `setup` script.

```bash
curl -s https://raw.githubusercontent.com/markosamuli/macos-machine/master/install.sh | bash -
```

## Getting Started

Clone this project locally and run the `./setup` script.

```bash
git clone https://github.com/markosamuli/macos-machine
cd macos-machine
./setup
```

## Local options

You can pass custom variables to the Ansible playbook and roles by creating
a [`machine.yaml`][machine.yaml] file to customise your configuration.

```bash
cp machine.yaml.example machine.yaml
```

The `setup` script will detect if this file exists and passes it to the
Ansible Playbook with `--extra-vars`.

[machine.yaml]: machine.yaml

## Software installed by the playbooks

### Installation tools

The following tools are prerequisites and always installed during setup if not
already found on the system.

- Xcode Command Line Tools
- [Homebrew](https://brew.sh/)
- [Ansible](https://www.ansible.com/) v2.7 installed with Homebrew
- [Python](https://www.python.org/) v3.7 installed with Homebrew

### Desktop applications

[iTerm2] terminal will be installed on all environments.

To install [Google Drive File Stream]:

```yaml
install_gdfs: true
```

To install [Slack] desktop application:

```yaml
install_slack: true
```

[iTerm2]: https://www.iterm2.com/
[Slack]: https://slack.com/downloads/osx
[Google Drive File Stream]: https://support.google.com/drive/answer/7329379?hl=en

### Shell

Latest version of [Zsh] will be installed from Homebrew.

[Zsh]: https://www.zsh.org/

### Command line tools

- [GNU Wget]
- [GNU sed] as `gsed` command
- [GNU tar] as `gtar` command
- [jq] command-line JSON processor
- [The Silver Searcher] (`ag` command) code searching utility similar to `ack`
- [htop] process viewer for console
- [ShellCheck] static analysis tool for shell scripts
- [shfmt] formatter for shell scripts
- [asciinema] for recording terminal session

[GNU Wget]: https://www.gnu.org/software/wget/
[GNU sed]: https://www.gnu.org/software/sed/
[GNU tar]: https://www.gnu.org/software/tar/
[jq]: https://stedolan.github.io/jq/
[htop]: https://hisham.hm/htop/
[The Silver Searcher]: https://github.com/ggreer/the_silver_searcher
[shellcheck]: https://github.com/koalaman/shellcheck
[shfmt]: https://github.com/mvdan/sh
[asciinema]: https://asciinema.org/

### macOS customization and automation

To install [Hazel] automation tool:

```yaml
install_hazel: true
```

To install [Hammerspoon] automation tool:

```yaml
install_hammerspoon: true
```

[Hazel]: https://www.noodlesoft.com/
[Hammerspoon]: https://www.hammerspoon.org/

### Editors

[Visual Studio Code] will be installed on all environments.

Latest [Vim] package will be installed from Homebrew.

To install [MacVim] instead of Vim, update `machine.yaml` with the following
configuration:

```yaml
install_macvim: true
```

To install [JetBrains Toolbox] to install and manage JetBrains applications:

```yaml
install_jetbrains_toolbox: true
```

[Visual Studio Code]: https://code.visualstudio.com/
[Vim]: https://www.vim.org/
[MacVim]: https://github.com/macvim-dev/macvim
[JetBrains Toolbox]: https://www.jetbrains.com/toolbox-app/

### asdf version manager

You can install [asdf] version manager by adding the following
option to your [`machine.yaml`][machine.yaml]:

```yaml
install_asdf: true
```

To configure [asdf plugins] and package versions to install, add them
into your [`machine.yaml`][machine.yaml] configuration.

```yaml
asdf_plugins:
  - name: kubectl
  - name: concourse
```

Note that some of the playbooks remove conflicting asdf plugins and
versions if a respective tool is installed using another package
or version manager.

[asdf]: https://asdf-vm.com
[asdf plugins]: https://asdf-vm.com/#/plugins-all

### Python

Use [pyenv] to install and manage Python versions for the current user:

- [pyenv]
- [pyenv-virtualenv]
- [Python] v2.7 and v3.7 installed with pyenv

You can disable installation by adding the following option to
your [`machine.yaml`][machine.yaml]:

```yaml
install_python: false
```

The [markosamuli.pyenv] role will modify your `.bashrc` and `.zshrc` files
during the setup. If you want to disable this, edit `machine.yaml` file
and disable the following configuration option.

```yaml
pyenv_init_shell: false
```

[Python]: https://www.python.org/
[pyenv]: https://github.com/pyenv/pyenv
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv

### Ruby

To install Ruby for development, enable it in your `machine.yaml` configuration:

```yaml
install_ruby: true
```

This will install:

- [rbenv] using [zzet.rbenv] role
- [Ruby] version 2.6.3 with rbenv

To change the installed rubies and default version, add the following to your
`machine.yaml` file and customize it to your needs:

```yaml
rbenv:
  env: user
  version: v1.1.2
  default_ruby: 2.6.3
  rubies:
    - version: 2.6.3
```

The role doesn't update your `.bashrc` or `.zshrc` files, so you need to add
something like below to initialize rbenv in your shell:

```bash
if [ -z "${RBENV_ROOT}" ]; then
  if [ -d "$HOME/.rbenv" ]; then
    export PATH=$HOME/.rbenv/bin:$PATH;
    export RBENV_ROOT=$HOME/.rbenv;
    eval "$(rbenv init -)";
  fi
fi
```

[zzet.rbenv]: https://github.com/zzet/ansible-rbenv-role
[rbenv]: https://github.com/rbenv/rbenv
[Ruby]: https://www.ruby-lang.org/en/

### Node.js

- [Node Version Manager] (NVM)
- [Node.js] LTS installed with NMV

You can disable installation by adding the following option to
your [`machine.yaml`][machine.yaml]:

```yaml
install_nodejs: false
```

[Node Version Manager]: https://github.com/creationix/nvm
[Node.js]: https://nodejs.org/en/

### Go

[Go programming language] installed using [markosamuli.golang]
Ansible role.

You can disable installation by adding the following option to
your [`machine.yaml`][machine.yaml]:

```yaml
install_golang: false
```

[Go programming language]: https://golang.org/

### Lua

You can install [Lua] programming language by adding the following
option to your [`machine.yaml`][machine.yaml] file:

```yaml
install_lua: true
```

This will also install [LuaRocks] package manager and [luacheck]
rock using the custom [luarocks module].

[Lua]: https://www.lua.org/
[LuaRocks]: https://luarocks.org/
[luacheck]: https://github.com/mpeterv/luacheck
[luarocks module]: playbooks/library/luarocks.py

### Git

Latest version of [Git] will be installed from Homebrew.

[Git]: https://git-scm.com/

### Vagrant and VirtualBox

[Vagrant] and [VirtualBox] are no longer installed by default, but you can
enable them by adding:

```yaml
install_vagrant: true
```

[Vagrant]: https://www.vagrantup.com/
[VirtualBox]: https://www.virtualbox.org/

### Docker

[Docker for Mac] will be installed by default.

To disable installation, add:

```yaml
install_docker: false
```

[Docker for Mac]: https://docs.docker.com/docker-for-mac/

### Certbot

Install [Certbot] with:

```yaml
install_certbot: true
```

[Certbot]: https://certbot.eff.org

### Nmap

Install [Nmap](https://nmap.org/) utility for network discovery
and security auditing by adding:

```yaml
install_nmap: true
```

[Nmap]: https://nmap.org/

### Packer

To install [Packer] add:

```yaml
install_packer: true
```

[Packer]: https://packer.io/

### Terraform

Install [tfenv] version manager for [Terraform] and install the latest version.

Any previous conflicting installations using [asdf] or
[markosamuli.terraform] role are removed.

Disable installation with:

```yaml
install_terraform: false
```

[Terraform]: https://www.terraform.io/
[tfenv]: https://github.com/tfutils/tfenv

### Digital Ocean

Install [doctl] using Homebrew package manager by adding the following
option to your [`machine.yaml`][machine.yaml]:

```yaml
install_doctl: true
```

This will uninstall any conflicting asdf plugins and versions.

[doctl]: https://github.com/digitalocean/doctl

### Amazon Web Services

- [AWS CLI](https://aws.amazon.com/cli/)
- [aws-shell](https://github.com/awslabs/aws-shell) - interactive shell for
  AWS CLI
- [AWS Vault](https://github.com/99designs/aws-vault) - a vault for securely
  storing and accessing AWS credentials in development environments
- [cli53](https://github.com/barnybug/cli53) - command line tool for Amazon
  Route 53

You can disable installation by adding the following option to
your [`machine.yaml`][machine.yaml]:

```yaml
install_aws: false
```

### Google Cloud Platform

[Google Cloud SDK] installed from the archive file under user
home directory. You shouldn't try to install a global version
with these playbooks.

Default install path is in `~/google-cloud-sdk`, but you can
install it to another location, for example if you prefer
`~/opt/google-cloud-sdk` add the following option:

```yaml
gcloud_install_path: ~/opt
```

The [markosamuli.gcloud] role will modify your `.bashrc` and `.zshrc` files.
To disable this and manage the configuration yourself, disable the following
configuration option in the [`machine.yaml`][machine.yaml] file:

```yaml
gcloud_setup_shell: false
```

You can disable installation by adding the following option to
your [`machine.yaml`][machine.yaml]:

```yaml
install_gcloud: false
```

[Google Cloud SDK]: https://cloud.google.com/sdk/

## Changes to existing configuration

The installer creates empty `~/.bash_profile` and `~/.bashrc` files and makes
sure `~/.bashrc` is loaded from `~/.bash_profile`.

The installer makes changes to your `~/.bashrc` and `~/.zshrc` files, so take
backup copies of them before running the script.

## Ansible Roles

The following external Ansible roles are installed and used. See
[requirements.yml] file for the installed versions.

| Role | Build status |
|------|--------------|
| [markosamuli.aws-tools] | [![Build Status](https://travis-ci.org/markosamuli/ansible-aws-tools.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-aws-tools) |
| [markosamuli.gcloud] | [![Build Status](https://travis-ci.org/markosamuli/ansible-gcloud.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-gcloud) |
| [markosamuli.golang] | [![Build Status](https://travis-ci.org/markosamuli/ansible-golang.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-golang) |
| [markosamuli.nvm] | [![Build Status](https://travis-ci.org/markosamuli/ansible-nvm.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-nvm) |
| [markosamuli.packer] | [![Build Status](https://travis-ci.org/markosamuli/ansible-packer.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-packer) |
| [markosamuli.pyenv] | [![Build Status](https://travis-ci.org/markosamuli/ansible-pyenv.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-pyenv) |
| [markosamuli.terraform] | [![Build Status](https://travis-ci.org/markosamuli/ansible-terraform.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-terraform) |
| [markosamuli.vagrant] | [![Build Status](https://travis-ci.org/markosamuli/ansible-vagrant.svg?branch=master)](https://travis-ci.orgmarkosamuli/ansible-vagrant) |

[markosamuli.aws-tools]: https://github.com/markosamuli/ansible-aws-tools
[markosamuli.gcloud]: https://github.com/markosamuli/ansible-gcloud
[markosamuli.golang]: https://github.com/markosamuli/ansible-golang
[markosamuli.nvm]: https://github.com/markosamuli/ansible-nvm
[markosamuli.packer]: https://github.com/markosamuli/ansible-packer
[markosamuli.pyenv]: https://github.com/markosamuli/ansible-pyenv
[markosamuli.terraform]: https://github.com/markosamuli/ansible-terraform
[markosamuli.vagrant]: https://github.com/markosamuli/ansible-vagrant
[requirements.yml]: requirements.yml

## Development

Fix ansible-lint installation issues:

```bash
pip install virtualenv==16.3.0
```

Install pre-commit with pip:

```bash
pip install pre-commit
```

Install [pre-commit] hooks:

```bash
make install-git-hooks
```

[pre-commit]: https://pre-commit.com/

## References

This is based on my previous setup [markosamuli/machine] that was forked off
from  [caarlos0/machine] to suit my needs.

[markosamuli/machine]: https://github.com/markosamuli/machine
[caarlos0/machine]: https://github.com/caarlos0/machine

## License

- [MIT](LICENSE)

## Authors

- [@markosamuli](https://github.com/markosamuli)
