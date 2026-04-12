# add local clis to path
export PATH="$PATH:/Users/miszo/.local/bin"
# pnpm
export PNPM_HOME="/Users/miszo/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
# ripgrep config
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/config
# ripgrep config end
export HOMEBREW_NO_AUTO_UPDATE=1
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
COMPLETION_WAITING_DOTS=true
export COLIMA_HOME="$HOME/.config/colima"
export MAS_NO_AUTO_INDEX=1
