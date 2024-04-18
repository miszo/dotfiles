alias vim="nvim"
alias npmplease="rm -rf node_modules/ && rm -f package-lock.json && npm install"
alias pnpmplease="rm -rf node_modules/ && rm -f pnpm-lock.yaml && pnpm install"
alias yarnplease="rm -rf node_modules/ && rm -f yarn.lock && yarn install"
alias npmconfig="vim ~/.npmrc"
alias yarnconfig="vim ~/.yarnrc"
alias zshconfig="vim $ZDOTDIR/.zshrc"
alias zshreset="source $ZDOTDIR/.zshrc"
alias bashconfig="vim ~/.bashrc"
alias gitconfig="vim ~/.config/git/config"
alias gitconfig-work="vim ~/.config/git/config-work"
alias hostsconfig="sudo vim /private/etc/hosts"
alias python="python3"
alias g="git"
alias dcu="docker compose up -d"
alias dcb="docker compose build"
alias dcd="docker compose down"
alias dcp="docker compose pull"
alias ssh="kitty +kitten ssh"
alias icat="kitty +kitten icat"

alias npmi="npm install"
alias npmci="npm ci"
alias npr="npm run"
alias nps="npm start"
alias npt="npm test"
alias yi="yarn install"
alias yr="yarn run"
alias ys="yarn start"
alias yt="yarn test"
alias pn="pnpm"
alias pni="pnpm install"
alias pnr="pnpm run"
alias pns="pnpm start"
alias pnt="pnpm test"
alias gcgb=git_clear_gone_branches
alias gpta=git_pull_them_all
alias cb=copy_branch

alias miszo_git=miszo_git_local_config

if [ "$(command -v bat)" ]; then
  unalias -m 'cat'
  alias cat='bat -pp --theme="ansi"'
fi
if [ "$(command -v eza)" ]; then
    unalias -m 'll'
    unalias -m 'l'
    unalias -m 'la'
    unalias -m 'ls'
    alias ls='eza -G --color auto -a -s type --icons'
    alias ll='eza -l --color always -a -s type --icons'
    alias tree='eza --tree --level=2 --color auto -a -s type --icons'
fi
