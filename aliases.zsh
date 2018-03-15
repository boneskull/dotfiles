# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

[[ $(get-env github) ]] && {
  alias git="$(get-env github)"
}

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias less="less -X"
alias miniterm="python3 -m serial.tools.miniterm"

trysource "${HOME}/.aliases.$(get-env os).zsh"
