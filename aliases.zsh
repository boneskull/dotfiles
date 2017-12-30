# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

[[ $(get_env github) ]] && {
  alias git="$(get_env github)"
}

[[ -f ${HOME}/.aliases.$(get_env os).zsh ]] && {
  source "${HOME}/.aliases.$(get_env os).zsh"
}

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"
alias less="less -X"

alias miniterm="python3 -m serial.tools.miniterm"
