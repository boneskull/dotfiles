FPATH="${HOME}/.zshfunctions:${FPATH}"

source "${HOME}/.functions.zsh"
source "${HOME}/.exports.zsh"
source "${HOME}/.aliases.zsh"
trysource "${NVM_DIR}/nvm.sh"
source "${HOME}/.antigen.zsh"
trysource "${HOME}/.extra.zsh"
trysource "${HOME}/.iterm2_shell_integration.zsh"
trysource /usr/local/Bluemix/bx/zsh_autocomplete
trysource ${HOME}/.travis/travis.sh
trysource "${HOME}/.$(get-env os).zshrc.zsh"
