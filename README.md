# github.com/miszo/dotfiles ![protected by gitleaks](https://img.shields.io/badge/protected%20by-gitleaks-blue) [![gitleaks status](https://github.com/miszo/dotfiles/actions/workflows/gitleaks.yml/badge.svg?branch=main)](https://github.com/miszo/dotfiles/actions/workflows/gitleaks.yml)

Miszo Radomski's dotfiles, managed with [`chezmoi`](https://github.com/twpayne/chezmoi).

Install them with:

```sh
    //https
    chezmoi init https://github.com/miszo/dotfiles.git

    // ssh
    chezmoi init git@github.com:miszo/dotfiles.git
```

Personal secrets are stored in [1Password](https://1password.com), and you'll
need the [1Password CLI](https://developer.1password.com/docs/cli/) installed.

To list possible commands just run:

```sh
    make
```

Bootstrap dependencies and git hooks with:

```sh
    make bootstrap
```

To run `gitleaks` locally:

```sh
    make gitleaks
```
