[[ -f ${HOME}/.exports.zsh ]] && \
  source "${HOME}/.exports.zsh"

[[ -f ${HOME}/.aliases.zsh ]] && \
  source "${HOME}/.aliases.zsh"

[[ -f ${HOME}/.antigen.zsh ]] && \
  source "${HOME}/.antigen.zsh"

[[ -f ${HOME}/.$(get_env os).zshrc.zsh ]] && \
  source "${HOME}/.$(get_env os).zshrc.zsh"

[[ -f ${HOME}/.extra.zsh ]] && \
  source "${HOME}/.extra.zsh"

[[ -f ${HOME}/.iterm2_shell_integration.zsh ]] && \
  source ${HOME}/.iterm2_shell_integration.zsh

[[ -f /usr/local/Bluemix/bx/zsh_autocomplete ]] && \
 source /usr/local/Bluemix/bx/zsh_autocomplete

[ -f /Users/boneskull/.travis/travis.sh ] && \
 source /Users/boneskull/.travis/travis.sh
