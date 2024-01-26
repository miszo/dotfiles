eval $(thefuck --alias)
eval $(gh completion -s zsh)
eval "$(/opt/homebrew/bin/brew shellenv)"
. /opt/homebrew/etc/profile.d/z.sh
# 1password cli
eval "$(op completion zsh)"; compdef _op op
source ${HOME}/.config/op/plugins.sh
# 1password cli end

source ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

if type pipx &>/dev/null; then
  autoload -U bashcompinit
  bashcompinit

  eval "$(register-python-argcomplete pipx)"
fi

# set java env variables
[[ -f ~/.asdf/plugins/java/set-java-home.zsh ]] && . ~/.asdf/plugins/java/set-java-home.zsh || true

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true
