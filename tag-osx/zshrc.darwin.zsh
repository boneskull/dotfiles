# zshrc for darwin

[[ $(get-env homebrew) ]] && {
  # setup for brew-file
  trysource $(brew --prefix)/etc/brew-wrap
  trysource $(brew --prefix)/etc/profile.d/z.sh
}
