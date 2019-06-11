#FPATH="${HOME}/.zshfunctions:${FPATH}"

# extglob support
setopt extendedglob

source "${HOME}/.functions.zsh"
source "${HOME}/.exports.zsh"
source "${HOME}/.aliases.zsh"
trysource "${NVM_DIR}/nvm.sh"
trysource "${HOME}/.extra.zsh"
trysource "${HOME}/.iterm2_shell_integration.zsh"
trysource "${HOME}/.travis/travis.sh"
source "${HOME}/.antigen.zsh"
source "${HOME}/.completions.zsh"
trysource "${HOME}/.$(get-env os).zshrc.zsh"
