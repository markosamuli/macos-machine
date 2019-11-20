PRE_COMMIT := $(shell command -v pre-commit 2> /dev/null)
TRAVIS := $(shell command -v travis 2> /dev/null)
SHELLCHECK := $(shell command -v shellcheck 2> /dev/null)
SHFMT := $(shell command -v shfmt 2> /dev/null)

PRE_COMMIT_HOOKS = .git/hooks/pre-commit
PRE_PUSH_HOOKS = .git/hooks/pre-push
COMMIT_MSG_HOOKS = .git/hooks/commit-msg

.PHONY: all
all: install-git-hooks lint

.PHONY: update
update:
	@./update-roles

.PHONY: lint
lint: pre-commit

.PHONY: pre-commit
pre-commit: install-git-hooks
ifndef SHELLCHECK
	$(error "shellcheck not found, try: 'brew install shellcheck'")
endif
ifndef SHFMT
	$(error "shfmt not found, try: 'brew install shfmt'")
endif
ifndef PRE_COMMIT
	$(error "pre-commit not found, try: 'brew install pre-commit'")
else
	@pre-commit run -a -v
endif

.PHONY: travis-lint
travis-lint:
ifndef PRE_COMMIT
	$(error "pre-commit not found, try: 'brew install pre-commit'")
else
	@pre-commit run -a travis-lint -v
endif

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

.PHONY: install-git-hooks
install-git-hooks: $(PRE_COMMIT_HOOKS) $(PRE_PUSH_HOOKS) $(COMMIT_MSG_HOOKS)

$(PRE_COMMIT_HOOKS):
	@pre-commit install --install-hooks

$(PRE_PUSH_HOOKS):
	@pre-commit install --install-hooks -t pre-push

$(COMMIT_MSG_HOOKS):
	@pre-commit install --install-hooks -t commit-msg
