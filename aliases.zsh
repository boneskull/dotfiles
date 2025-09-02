# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

[[ $(get-env bat) ]] && {
  alias cat="bat"
  alias more="bat"
} || {
  alias more="less -X"
}

alias myip="dig +short myip.opendns.com @resolver1.opendns.com"

alias kn='killall node'

alias fix-lockfile='trash node_modules packages/*/node_modules; npm i && npm ls && git add -A package-lock.json'
