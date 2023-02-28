# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

[[ $(get-env github) ]] && {
  eval "$(hub alias -s)"
}

[[ $(get-env bat) ]] && {
  alias cat="bat"
  alias more="bat"
} || {
  alias more="less -X"
}

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

[[ $(get-env nvm) ]] && {
  alias npm="$(dirname $(nvm which current))/npm"
}
