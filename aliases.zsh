# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

(( $+commands[bat] )) && {
  alias cat="bat --paging=never"
  alias more="bat"
} || {
  alias more="less -X"
}

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

(( $+commands[eza] )) && alias ls="eza --icons --git"

alias kn='killall node'
