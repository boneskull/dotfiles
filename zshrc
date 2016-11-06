[[ -f ${HOME}/.exports.zsh ]] && {
  source "${HOME}/.exports.zsh"
}

[[ -f ${HOME}/.aliases.zsh ]] && {
  source "${HOME}/.aliases.zsh"
}

[[ -f ${HOME}/.antigen.zsh ]] && {
  source "${HOME}/.antigen.zsh"
}

[[ -f ${HOME}/.$(get_env os).zshrc.zsh ]] && {
  source "${HOME}/.$(get_env os).zshrc.zsh"
}

[[ -f ${HOME}/.extra.zsh ]] && {
  source "${HOME}/.extra.zsh"
}
