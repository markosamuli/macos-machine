# Makefile for https://github.com/markosamuli/macos-machine
#
# Self-documented help from:
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

###
# Makefile configuration
###

.DEFAULT_GOAL := help

# We want our output silent by default, use VERBOSE=1 make <command> ...
# to get verbose output.
ifndef VERBOSE
.SILENT:
endif

###
# Define environment variables in the beginning of the file
###

UNAME_S  := $(shell uname -s)
BREW_BIN = $(shell command -v brew 2>/dev/null)
GO_BIN = $(shell command -v go 2>/dev/null)
PYENV_BIN = $(shell command -v pyenv 2>/dev/null)
PRE_COMMIT_BIN = $(shell pre-commit --version 2>&1 | head -1 | grep -q 'pre-commit [12]\.' && command -v pre-commit)
PYLINT_BIN = $(shell pylint --version 2>&1 | head -1 | grep -q 'pylint 2' && command -v pylint)
SHELLCHECK_BIN = $(shell command -v shellcheck 2>/dev/null)
SHFMT_BIN = $(shell command -v shfmt 2>/dev/null)

###
# Define local variables after environment variables
###

# Paths to supported Git hooks
pre_commit_hooks = .git/hooks/pre-commit
pre_push_hooks 	 = .git/hooks/pre-push
commit_msg_hooks = .git/hooks/commit-msg
git_hooks = $(pre_commit_hooks) $(pre_push_hooks) $(commit_msg_hooks)

###
# Setup
###

.PHONY: setup
setup:  ## run setup with default options
	./setup

.PHONY: setup-development
setup-development: init setup-git-hooks ## setup requirements for local development

.PHONY: update
update: setup-ansible ## update Ansible roles
	./setup --no-install-ansible --update-roles --no-run-playbook

.PHONY: clean
clean:  ## delete local development dependencies
	-rm -rf playbooks/roles/markosamuli.*
	-rm -rf playbooks/roles/zzet.rbenv
	./scripts/delete_virtualenv.sh

###
# Setup: Python, pyenv and virtualenv
###

.PHONY: setup-pyenv
setup-pyenv:
ifeq ($(PYENV_BIN),)
	$(MAKE) python
endif

.PHONY: setup-pyenv-virtualenv
setup-pyenv-virtualenv: setup-pyenv
	./scripts/create_virtualenv.sh

.PHONY: setup-requirements
setup-requirements: setup-pyenv-virtualenv
	pip install -q -r requirements.txt

.PHONY: setup-dev-requirements
setup-dev-requirements: setup-pyenv-virtualenv
	pip install -q -r requirements.dev.txt

###
# Setup: Homebrew
###

.PHONY: setup-homebrew
setup-homebrew:
ifeq ($(BREW_BIN),)
ifeq ($(UNAME_S),Linux)
	$(MAKE) linuxbrew
endif
ifeq ($(UNAME_S),Darwin)
	./setup --no-install-ansible --no-run-playbook --no-install-roles
endif
endif

###
# Setup: pre-commit and Git hooks
###

.PHONY: setup-pre-commit
setup-pre-commit:
ifeq ($(PRE_COMMIT_BIN),)
	$(MAKE) setup-dev-requirements
endif

.PHONY: setup-git-hooks
setup-git-hooks: $(git_hooks)

$(pre_commit_hooks): | setup-pre-commit
	pre-commit install --install-hooks

$(pre_push_hooks): | setup-pre-commit
	pre-commit install --install-hooks -t pre-push

$(commit_msg_hooks): | setup-pre-commit
	pre-commit install --install-hooks -t commit-msg

###
# Setup: Go
###

.PHONY: setup-golang
setup-golang:
ifeq ($(GO_BIN),)
	$(MAKE) golang
endif

###
# Setup: Shellcheck and shfmt
###

.PHONY: setup-shellcheck
setup-shellcheck:
ifeq ($(SHELLCHECK_BIN),)
	./setup -q -t shellcheck
endif

.PHONY: setup-shfmt
setup-shfmt: setup-golang
ifeq ($(SHFMT_BIN),)
	GO111MODULE=on go get mvdan.cc/sh/v3/cmd/shfmt
endif

###
# Setup: pylint
###

.PHONY: setup-pylint
setup-pylint:
ifeq ($(PYLINT_BIN),)
	$(MAKE) setup-dev-requirements
endif

###
# Linting and formatting
###

.PHONY: lint
lint: setup-pre-commit setup-shfmt setup-shellcheck setup-pylint  ## run pre-commit hooks on all files
	pre-commit run -a

.PHONY: python-format
python-format: setup-pre-commit  ## format Python files
	-pre-commit run -a requirements-txt-fixer
	-pre-commit run -a yapf

.PHONY: python-lint
python-lint: setup-pre-commit setup-pylint python-format  ## lint and format Python files
	pre-commit run -a check-ast
	pre-commit run -a flake8
	pre-commit run -a pylint

.PHONY: travis-lint
travis-lint: setup-pre-commit  ## lint .travis.yml file
	pre-commit run -a travis-lint

###
# Ansible setup
###

ANSIBLE_INSTALLED = $(shell ansible --version 2>&1 | head -1 | grep -q 'ansible 2' && echo true)

.PHONY: setup-ansible
setup-ansible:
ifneq ($(ANSIBLE_INSTALLED),true)
	$(MAKE) install-ansible
endif

.PHONY: install-ansible
install-ansible:  ## install Ansible without roles or running playbooks
	./setup \
		--install-ansible \
		--no-run-playbook \
		--no-install-roles

.PHONY: install-roles
install-roles:  ## install Ansible roles
	./setup --no-run-playbook

.PHONY: list-tags
list-tags:  # list Ansible tags
	./setup --no-run-playbook --no-install-roles -l

.PHONY: clean-roles
clean-roles: setup-requirements  ## remove outdated Ansible roles
	./scripts/clean_roles.py

.PHONY: update-roles
update-roles: setup-requirements  ## update Ansible roles in the requirements.yml file
	./scripts/update_roles.py

.PHONY: latest-roles
latest-roles: update-roles clean-roles install-roles  # update Ansible roles and install new versions

###
# Initialise requirements for running playbooks
###

.PHONY: init
init: setup-ansible setup-requirements

###
# Playbooks
###

.PHONY: aws
aws: init playbooks/roles/markosamuli.aws_tools  ## install AWS tools
	./scripts/configure.py install_aws true
	./setup -q -t aws

.PHONY: docker
docker: init ## install Docker
	./scripts/configure.py install_docker true
	./setup -q -t docker

.PHONY: editors
editors: init ## install IDEs and code editors
	./setup -q -t editors

.PHONY: gcloud
gcloud: init playbooks/roles/markosamuli.gcloud  ## install Google Cloud SDK
	./scripts/configure.py install_gcloud true
	./setup -q -t gcloud

.PHONY: golang
golang: init playbooks/roles/markosamuli.golang  ## install Go programming language
	./scripts/configure.py install_golang true
	./setup -q -t golang

.PHONY: lua
lua: init ## install Lua programming language
	./scripts/configure.py install_lua true
	./setup -q -t lua

.PHONY: node
node: init playbooks/roles/markosamuli.nvm ## install Node.js with NVM
	./scripts/configure.py install_nodejs true
	./setup -q -t node,nvm

.PHONY: permissions
permissions: init ## fix permissions in user home directory
	USER_HOME_FIX_PERMISSIONS=true ./setup -q -t permissions

# Do not create virtualenv if Python is not installed yet
.PHONY: python
python: setup-ansible playbooks/roles/markosamuli.pyenv ## install Python with pyenv
	./setup -q -t python,pyenv

.PHONY: ruby
ruby: init playbooks/roles/zzet.rbenv ## install Ruby with rbenv
	./scripts/configure.py install_ruby true
	./setup -q -t ruby,rbenv

.PHONY: rust
rust: init playbooks/roles/markosamuli.rust ## install Rust programming language
	./scripts/configure.py install_rust true
	./setup -q -t rust

.PHONY: shellcheck
shellcheck: init ## install shellcheck
	./setup -q -t shellcheck

.PHONY: terraform
terraform: init ## install Terraform
	./scripts/configure.py install_terraform true
	./setup -q -t terraform

.PHONY: tools
tools: init ## install tools
	./setup -q -t tools

.PHONY: zsh
zsh: init ## install zsh
	./scripts/configure.py install_zsh true
	./setup -q -t zsh

###
# Aliases for the playbooks
###

.PHONY: go
go: golang

###
# Ansible roles
###

playbooks/roles/zzet.rbenv:
	./setup --no-run-playbook

playbooks/roles/markosamuli.%:
	./setup --no-run-playbook

###
# This Makefile uses self-documenting help commands
###

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort -d | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
