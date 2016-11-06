
[[ $(get_env debian) ]] && {
  antigen bundle debian # apt integration
}

[[ $(get_env systemd) ]] && {
  antigen bundle systemd
}
