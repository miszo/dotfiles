# github.com/miszo/dotfiles

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
