[[ $(get-env debian) ]] && {
  antigen bundle debian # apt integration
}

[[ $(get-env systemd) ]] && {
  antigen bundle systemd
}
