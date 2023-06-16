# github.com/miszo/dotfiles ![protected by gitleaks](https://img.shields.io/badge/protected%20by-gitleaks-blue) [![gitleaks status](https://github.com/miszo/dotfiles/actions/workflows/gitleaks.yml/badge.svg?branch=main)](https://github.com/miszo/dotfiles/actions/workflows/gitleaks.yml)

Miszo Radomski's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Install them with:

    //https
    chezmoi init https://github.com/miszo/dotfiles.git

    // ssh
    chezmoi init git@github.com:miszo/dotfiles.git

Personal secrets are stored in [1Password](https://1password.com) and you'll
need the [1Password CLI](https://developer.1password.com/docs/cli/) installed.
Login to 1Password with:

    eval $(op signin)

To run `gitleaks` on `pre-commit` git hook do the following:

1. Auto-update the config to the latest repos' versions by executing `pre-commit autoupdate`
2. Install with pre-commit install
3. Now you're all set!
