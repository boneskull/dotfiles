#FPATH="${HOME}/.zshfunctions:${FPATH}"

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

trysource "${HOME}/.$(get-env os).zshrc.zsh"

trysource "${HOME}/.extra.zsh"
