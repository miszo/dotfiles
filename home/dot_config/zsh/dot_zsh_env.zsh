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
# don't install formulae that are managed by mise-en-place
export HOMEBREW_BUNDLE_BREW_SKIP='asdf node pnpm yarn bun deno go just lua zig rust ruby chezmoi php'
export HOMEBREW_NO_ANALYTICS=1
export SSH_AUTH_SOCK=$HOME/.1password/agent.sock
export COMPLETION_WAITING_DOTS=true
export COLIMA_HOME="$HOME/.config/colima"
export MAS_NO_AUTO_INDEX=1

# Ctrl+n
export DEJA_CYCLE_KEY=^N
# Shift+→
export DEJA_CYCLE_FUZZY_KEY='^[[1;2C'
# Shift+←
export DEJA_CYCLE_FUZZY_BACK_KEY='^[[1;2D'
# Empty key (disable)
export DEJA_TOGGLE_EMPTY_KEY=
# Escape key
export DEJA_DISMISS_KEY=^[
