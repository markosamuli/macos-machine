# Makefile for https://github.com/markosamuli/macos-machine
#
# Self-documented help from:
# https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

# Get paths to required commands
TRAVIS = $(shell command -v travis 2>/dev/null)
SHELLCHECK = $(shell command -v shellcheck 2>/dev/null)
SHFMT = $(shell command -v shfmt 2>/dev/null)

.PHONY: default
default: help

.PHONY: help
help:  ## print this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup:  ## run setup with default options
	@./setup

# Get paths to pyenv and Python commmands
PYENV_BIN = $(shell command -v pyenv 2>/dev/null)
PYTHON_BIN = $(shell command -v python 2>/dev/null)

# Python version to use for the virtualenv
PYTHON_VERSION = $(shell pyenv install --list | sed 's/ //g' | grep "^3\.7\.[0-9]*$$" | sort -r | head -1)
PYTHON_VERSION_PATH = $(HOME)/.pyenv/versions/$(PYTHON_VERSION)

# Virtualenv name will be generated from the repository name
PYENV_VIRTUALENV = $(shell basename "$(shell pwd)")
PYENV_VIRTUALENV_PATH = $(HOME)/.pyenv/versions/$(PYENV_VIRTUALENV)

# Get local pyenv version
PYENV_LOCAL = $(shell pyenv local 2>/dev/null)

.PHONY: setup-pyenv-virtualenv
setup-pyenv-virtualenv:  ## setup virtualenv with pyenv for development
ifeq ($(PYENV_BIN),)
	@echo "pyenv is not installed"
	@exit 1
endif
ifeq ($(PYENV_LOCAL),)
# Local version is not defined
# 1. Install Python if missing
# 2. Create virtualenv if missing
# 3. Set local virtualenv
ifeq (,$(wildcard $(PYTHON_VERSION_PATH)))
	@echo "Install Python $(PYTHON_VERSION)"
	@pyenv install $(PYTHON_VERSION)
endif
ifeq (,$(wildcard $(PYENV_VIRTUALENV_PATH)))
	@echo "Creating virtualenv '$(PYENV_VIRTUALENV)' with pyenv using Python $(PYTHON_VERSION)"
	@pyenv virtualenv $(PYTHON_VERSION) $(PYENV_VIRTUALENV)
endif
	@echo "Using existing virtualenv '$(PYENV_VIRTUALENV)'"
	@pyenv local $(PYENV_VIRTUALENV)
else
# Local version is set
ifneq ($(PYENV_LOCAL),$(PYENV_VIRTUALENV))
	@echo "WARNING: pyenv local version should be $(PYENV_VIRTUALENV), found $(PYENV_LOCAL)"
endif
endif

.PHONY: setup-requirements
setup-requirements: setup-pyenv-virtualenv  ## setup requirements for running the scripts
	@pip install -q -r requirements.txt

.PHONY: setup-dev-requirements
setup-dev-requirements: setup-pyenv-virtualenv  ## setup development requirements
	@pip install -q -r requirements.dev.txt

PRE_COMMIT_INSTALLED = $(shell pre-commit --version 2>&1 | head -1 | grep -q 'pre-commit 1' && echo true)

.PHONY: setup-pre-commit
setup-pre-commit:  ## setup pre-commit if not installed
ifneq ($(PRE_COMMIT_INSTALLED),true)
	@$(MAKE) setup-dev-requirements
endif

.PHONY: lint
lint: pre-commit  ## lint source code

.PHONY: pre-commit
pre-commit: setup-pre-commit  ## run pre-commit hooks on all files
ifndef SHELLCHECK
	$(error "shellcheck not found, try: 'brew install shellcheck'")
endif
ifndef SHFMT
	$(error "shfmt not found, try: 'brew install shfmt'")
endif
	@pre-commit run -a -v

.PHONY: python-lint
python-lint: setup-pre-commit  ## lint and format Python files
	@pre-commit run -a check-ast -v
	@pre-commit run -a requirements-txt-fixer -v
	@pre-commit run -a yapf -v
	@pre-commit run -a flake8 -v
	@pre-commit run -a pylint -v

.PHONY: travis-lint
travis-lint: setup-pre-commit  ## lint .travis.yml file
	@pre-commit run -a travis-lint -v

.PHONY: setup-ansible
install-ansible:  ## install Ansible without roles or running playbooks
	@./setup \
		--install-ansible \
		--no-run-playbook \
		--no-install-roles \
		--print-versions \
		--verbose

.PHONY: install-roles
install-roles:  ## install Ansible roles
	@./setup --no-run-playbook

.PHONY: list-tags
list-tags:  # list Ansible tags
	@./setup --no-run-playbook --no-install-roles -l

.PHONY: clean-roles
clean-roles: setup-requirements  ## remove outdated Ansible roles
	@./scripts/clean_roles.py

.PHONY: update-roles
update-roles: setup-requirements  ## update Ansible roles in the requirements.yml file
	@./scripts/update_roles.py

.PHONY: latest-roles
latest-roles: update-roles clean-roles install-roles  # update Ansible roles and install new versions

.PHONY: aws
aws:  ## install AWS tools
	@./setup -q -t aws

.PHONY: docker
docker:  ## install Docker
	@./setup -q -t docker

.PHONY: gcloud
gcloud: playbooks/roles/markosamuli.gcloud  ## install Google Cloud SDK
	@./setup -q -t gcloud

.PHONY: golang
golang: playbooks/roles/markosamuli.golang  ## install Go programming language
	@./setup -q -t golang

.PHONY: lua
lua: ## install Lua programming language
	@./setup -q -t lua

.PHONY: node
node: playbooks/roles/markosamuli.nvm  ## install Node.js with NVM
	@./setup -q -t node,nvm

.PHONY: permissions
permissions:  ## fix permissions in user home directory
	@USER_HOME_FIX_PERMISSIONS=true ./setup -q -t permissions

.PHONY: python
python: playbooks/roles/markosamuli.pyenv  ## install Python with pyenv
	@./setup -q -t python,pyenv

.PHONY: ruby
ruby: playbooks/roles/zzet.rbenv  ## install Ruby with rbenv
	@./setup -q -t ruby,rbenv

.PHONY: rust
rust: ## install Rust programming language
	@./setup -q -t rust

.PHONY: terraform
terraform: ## install Terraform
	@./setup -q -t terraform

.PHONY: tools
tools:  ## install tools
	@./setup -q -t tools

playbooks/roles/zzet.rbenv:
	@./setup --no-run-playbook

playbooks/roles/markosamuli.%:
	@./setup --no-run-playbook

PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)  ## install Git hooks

$(PRE_COMMIT_HOOKS): setup-pre-commit  ## install pre-commit hooks
	@pre-commit install --install-hooks

$(PRE_PUSH_HOOKS): setup-pre-commit  ## install pre-push hooks
	@pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS): setup-pre-commit  ## install commit-msg hooks
	@pre-commit install --install-hooks -t commit-msg
