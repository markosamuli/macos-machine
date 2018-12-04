# Changelog

## [Unreleased changes]

### Added

* Added pre-commit hooks
* Lint Ansible playbooks with ansible-lint
* Run Xcode 10.1 Travis builds
* Set pyenv global Python to version 2.7.15

### Fixed

* Ansible coding style errors
* Do not override Google Cloud SDK version

### Changed

* Install pyenv with markosamuli.pyenv role
* Do not install virtualenv pip
* Install Python versions with markosamuli.pyenv role
* Force use of Ansible from Homebrew during setup

### Removed

* Do not install Python with Homebrew
* Do not install Yarn with Homebrew
* Remove support for installing NPM packages
