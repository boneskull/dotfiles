# extglob support
setopt extendedglob

source "${HOME}/.functions.zsh"
trysource "${HOME}/.functions.$(get-env os).zsh"

source "${HOME}/.exports.zsh"
trysource "${HOME}/.exports.$(get-env os).zsh"

source "${HOME}/.aliases.zsh"
source "${HOME}/.aliases.$(get-env os).zsh"

source "${HOME}/.antigen.zsh"
trysource "${HOME}/.antigen.$(get-env os).zsh"

source "${HOME}/.completions.zsh"
trysource "${HOME}/.completions.$(get-env os).zsh"

trysource "${HOME}/.zshrc.$(get-env os).zsh"

export PATH="${PATH}:./node_modules/.bin"

trysource "${HOME}/.extra.zsh"
