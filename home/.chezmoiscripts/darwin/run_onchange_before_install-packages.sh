#!/bin/bash

set -eufo pipefail

echo "Run brew bundle..."
brew bundle --no-lock --file=~/Brewfile

echo "Installing software dependency versions via asdf..."
while IFS= read -r plugin; do
  asdf plugin add "${plugin}" || true # ignore fail
  asdf install "${plugin}"
done < <(cut -d ' ' -f1 < ~/.tool-versions)

asdf reshim
