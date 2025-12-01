# zshrc for darwin

[[ -n "${HOMEBREW_PREFIX}" ]] && {
  # setup for brew-file
  trysource "${HOMEBREW_PREFIX}/etc/brew-wrap"
  trysource "${HOMEBREW_PREFIX}/etc/profile.d/z.sh"
}

# https://stackoverflow.com/questions/45004352/error-enfile-file-table-overflow-scandir-while-run-reaction-on-mac
#
# may need to run this as root:
#
# echo kern.maxfiles=524288 | sudo tee -a /etc/sysctl.conf
# echo kern.maxfilesperproc=524288 | sudo tee -a /etc/sysctl.conf
# sudo sysctl -w kern.maxfiles=524288
# sudo sysctl -w kern.maxfilesperproc=524288

# ¯\_(ツ)_/¯
ulimit -n unlimited
