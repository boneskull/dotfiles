# zshrc for darwin

# setup for brew-file
[[ $(get_env homebrew) && -f $(brew --prefix)/etc/brew-wrap ]] && {
  source $(brew --prefix)/etc/brew-wrap
}

[[ -f ${HOME}/.iterm2_shell_integration.zsh ]] && {
  source ${HOME}/.iterm2_shell_integration.zsh
}

[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && {
  . /usr/local/etc/profile.d/z.sh
}
