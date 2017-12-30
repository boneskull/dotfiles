[[ -f ${HOME}/.exports.zsh ]] && \
  source "${HOME}/.exports.zsh"

[[ -f ${HOME}/.aliases.zsh ]] && \
  source "${HOME}/.aliases.zsh"

[[ -f ${NVM_DIR}/nvm.sh ]] && \
  source "${NVM_DIR}/nvm.sh"

[[ -f ${ANTIGEN_HOME}/antigen.zsh ]] && \
  source "${ANTIGEN_HOME}/antigen.zsh"

[[ -f ${HOME}/.antigen.zsh ]] && \
  source "${HOME}/.antigen.zsh"

[[ -f ${HOME}/.$(get_env os).zshrc.zsh ]] && \
  source "${HOME}/.$(get_env os).zshrc.zsh"

[[ -f ${HOME}/.extra.zsh ]] && \
  source "${HOME}/.extra.zsh"

[[ -f ${HOME}/.iterm2_shell_integration.zsh ]] && \
  source "${HOME}/.iterm2_shell_integration.zsh"

[[ -f /usr/local/Bluemix/bx/zsh_autocomplete ]] && \
 source "/usr/local/Bluemix/bx/zsh_autocomplete"

[[ -f ${HOME}/.travis/travis.sh ]] && \
 source "${HOME}/.travis/travis.sh"
