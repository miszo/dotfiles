#!/bin/bash

function install_homebrew() {
  if ! command -v brew &> /dev/null
  then
      echo "Installing Homebrew..."
      curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
  fi
}

function install_dependencies() {
  echo "Run brew bundle..."
  BREWFILE_PATH="$(pwd)/scripts/Brewfile_bootstrap"
  TOOLVERSIONS_PATH="$(pwd)/.tool-versions"
  brew bundle --no-lock --file=$BREWFILE_PATH

  echo "Installing software dependency versions via asdf..."
  while IFS= read -r plugin; do
    asdf plugin add "${plugin}" || true # ignore fail
    asdf install "${plugin}"
  done < <(cut -d ' ' -f1 < $TOOLVERSIONS_PATH)

  asdf reshim
}

function setup_pre-commit() {
  pre-commit autoupdate
  pre-commit install
}

function bootstrap() {
  install_homebrew
  install_dependencies
  setup_pre-commit
}

bootstrap