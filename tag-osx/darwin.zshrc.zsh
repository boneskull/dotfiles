# zshrc for darwin

# setup for brew-file
[[ $(get_env homebrew) && -f $(brew --prefix)/etc/brew-wrap ]] && {
  source $(brew --prefix)/etc/brew-wrap
}

[[ -f $(brew --prefix)/etc/profile.d/z.sh ]] && {
  . /usr/local/etc/profile.d/z.sh
}

[[ -f /usr/local/opt/nvm/nvm.sh ]] && {
  . /usr/local/opt/nvm/nvm.sh
}
