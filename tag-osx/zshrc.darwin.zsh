# zshrc for darwin

[[ $(get-env homebrew) ]] && {
  # setup for brew-file
  trysource $(brew --prefix)/etc/brew-wrap
  trysource $(brew --prefix)/etc/profile.d/z.sh
}

# https://stackoverflow.com/questions/45004352/error-enfile-file-table-overflow-scandir-while-run-reaction-on-mac
#
# may need to run this as root:
#
# echo kern.maxfiles=524288 | sudo tee -a /etc/sysctl.conf
# echo kern.maxfilesperproc=524288 | sudo tee -a /etc/sysctl.conf
# sudo sysctl -w kern.maxfiles=524288
# sudo sysctl -w kern.maxfilesperproc=524288
ulimit -n 524288 524288
