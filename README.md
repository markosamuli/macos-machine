# Development macOS Setup

| Branch  | Status |
|---------|--------|
| master  | [![Build Status](https://travis-ci.org/markosamuli/macos-machine.svg?branch=master)](https://travis-ci.org/markosamuli/macos-machine)
| develop | [![Build Status](https://travis-ci.org/markosamuli/macos-machine.svg?branch=develop)](https://travis-ci.org/markosamuli/macos-machine)

This is a collection of Ansible roles and tasks to setup a new developer machine
on macOS.

This setup has only been tested on the macOS Sierra and not against existing
installations.

See [markosamuli/linux-machine] for my Ubuntu Linux setup.

[markosamuli/linux-machine]: https://github.com/markosamuli/linux-machine

## Requirements

- OS X 10.10 or higher
- Xcode installed
- Git installed

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
a `machine.yaml` file to customise your configuration.

```bash
cp machine.yaml.example machine.yaml
```

The `setup` script will detect if this file exists and passes it to the
Ansible Playbook with `--extra-vars`.

## Software installed by the playbooks

### Installation tools

The following tools are prerequisites and always installed during setup if not
already found on the system.

- Xcode Command Line Tools
- [Homebrew](https://brew.sh/)
- [Ansible](https://www.ansible.com/) v2.7 installed with Homebrew
- [Python](https://www.python.org/) v3.7 installed with Homebrew

### Desktop applications

- [iTerm2](https://www.iterm2.com/)
- [Google Drive File Stream](https://support.google.com/drive/answer/7329379?hl=en)
- [Slack](https://slack.com/downloads/osx) desktop application

### Command line tools

- [GNU Wget](https://www.gnu.org/software/wget/)
- [jq](https://stedolan.github.io/jq/) command-line JSON processor
- [The Silver Searcher](https://github.com/ggreer/the_silver_searcher) code
  searching utility similar to `ack`

### Editors

- [Visual Studio Code]
- [Atom]

[Visual Studio Code]: https://code.visualstudio.com/
[Atom]: https://atom.io/

### Python

Use [pyenv] to install and manage Python versions for the current user:

- [pyenv]
- [pyenv-virtualenv]
- [Python] v2.7 and v3.7 installed with pyenv

[Python]: https://www.python.org/
[pyenv]: https://github.com/pyenv/pyenv
[pyenv-virtualenv]: https://github.com/pyenv/pyenv-virtualenv

### Node.js

- [Node Version Manager] (NVM)
- [Node.js] LTS installed with NMV

[Node Version Manager]: https://github.com/creationix/nvm
[Node.js]: https://nodejs.org/en/

### Other programming languages

- [Go programming language]

[Go programming language]: https://golang.org/

### Developer tools

- [Git](https://git-scm.com/)
- [Docker for Mac](https://docs.docker.com/docker-for-mac/)
- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

### DevOps and Cloud tools

- [Terraform](https://www.terraform.io/)
- [Packer](https://packer.io/)
- [Google Cloud SDK](https://cloud.google.com/sdk/)
- [AWS CLI](https://aws.amazon.com/cli/)
- [aws-shell](https://github.com/awslabs/aws-shell) - interactive shell for
  AWS CLI
- [AWS Vault](https://github.com/99designs/aws-vault) - a vault for securely
  storing and accessing AWS credentials in development environments
- [cli53](https://github.com/barnybug/cli53) - command line tool for Amazon
  Route 53
- [Certbot](https://certbot.eff.org/)
- [Nmap](https://nmap.org/) utility for network discovery and security auditing

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

Install [pre-commit] hooks:

```bash
pre-commit install
pre-commit install --hook-type pre-push
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
