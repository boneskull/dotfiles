FPATH="${HOME}/.zshfunctions:${FPATH}"

autoload trysource get-env set-env install-antigen update-antigen install-vundle

trysource "${HOME}/.exports.zsh"
trysource "${HOME}/.aliases.zsh"
trysource "${NVM_DIR}/nvm.sh"
trysource "${HOME}/.antigen.zsh"
trysource "${HOME}/.extra.zsh"
trysource "${HOME}/.iterm2_shell_integration.zsh"
trysource /usr/local/Bluemix/bx/zsh_autocomplete
trysource ${HOME}/.travis/travis.sh
trysource "${HOME}/.$(get-env os).zshrc.zsh"
