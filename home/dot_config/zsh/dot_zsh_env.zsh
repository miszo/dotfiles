export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/Users/miszo/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/highlighters
export PATH="$PATH:/Users/miszo/.local/bin"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"
# pnpm
export PNPM_HOME="/Users/miszo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# ripgrep config
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config
export HOMEBREW_NO_AUTO_UPDATE=1
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock