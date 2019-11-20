TRAVIS = $(shell command -v travis 2> /dev/null)
SHELLCHECK = $(shell command -v shellcheck 2> /dev/null)
SHFMT = $(shell command -v shfmt 2> /dev/null)

.PHONY: all
all: install-git-hooks lint

PYENV_BIN = $(shell command -v pyenv)
PYTHON_BIN = $(shell command -v python)
PYTHON_VERSION = 3.7.5
PYTHON_VERSION_PATH = $(HOME)/.pyenv/versions/$(PYTHON_VERSION)
PYENV_VIRTUALENV = macos-machine
PYENV_VIRTUALENV_PATH = $(HOME)/.pyenv/versions/$(PYENV_VIRTUALENV)
PYENV_LOCAL = $(shell pyenv local 2>/dev/null)

.PHONY: setup-pyenv-virtualenv
setup-pyenv-virtualenv:
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
setup-requirements: setup-pyenv-virtualenv
	@pip install -r requirements.txt

PRE_COMMIT_INSTALLED = $(shell pre-commit --version 2>&1 | head -1 | grep -q 'pre-commit 1' && echo true)

.PHONY: setup-pre-commit
setup-pre-commit:
ifneq ($(PRE_COMMIT_INSTALLED),true)
	$(MAKE) setup-requirements
endif

.PHONY: update
update:
	@./update-roles

.PHONY: lint
lint: pre-commit

.PHONY: pre-commit
pre-commit: setup-pre-commit
ifndef SHELLCHECK
	$(error "shellcheck not found, try: 'brew install shellcheck'")
endif
ifndef SHFMT
	$(error "shfmt not found, try: 'brew install shfmt'")
endif
	@pre-commit run -a -v

.PHONY: travis-lint
travis-lint: setup-pre-commit
	@pre-commit run -a travis-lint -v

.PHONY: roles
roles:
	@./setup -n

.PHONY: tools
tools:
	@./setup -q -t tools

.PHONY: golang
golang:
	@./setup -q -t golang

.PHONY: python
python:
	@./setup -q -t python,pyenv

.PHONY: ruby
ruby:
	@./setup -q -t ruby,rbenv

.PHONY: node
node:
	@./setup -q -t node,nvm

.PHONY: terraform
terraform:
	@./setup -q -t terraform

.PHONY: gcloud
gcloud:
	@./setup -q -t gcloud

.PHONY: docker
docker:
	@./setup -q -t docker

PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)

$(PRE_COMMIT_HOOKS): setup-pre-commit
	@pre-commit install --install-hooks

$(PRE_PUSH_HOOKS): setup-pre-commit
	@pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS): setup-pre-commit
	@pre-commit install --install-hooks -t commit-msg
