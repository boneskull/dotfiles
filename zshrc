#FPATH="${HOME}/.zshfunctions:${FPATH}"

# extglob support
setopt extendedglob

source "${HOME}/.functions.zsh"
source "${HOME}/.exports.zsh"
source "${HOME}/.aliases.zsh"
trysource "${NVM_DIR}/nvm.sh"
trysource "${HOME}/.extra.zsh"
source "${HOME}/.antigen.zsh"
source "${HOME}/.completions.zsh"
trysource "${HOME}/.$(get-env os).zshrc.zsh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
