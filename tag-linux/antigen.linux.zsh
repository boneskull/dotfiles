# Linux-specific antidote plugin loading
# Note: these load AFTER the main zsh-plugins.txt plugins

# Debian/apt integration
(( $+commands[apt-get] )) && {
  antidote bundle ohmyzsh/ohmyzsh path:plugins/debian
}

# Systemd integration
(( $+commands[systemctl] )) && {
  antidote bundle ohmyzsh/ohmyzsh path:plugins/systemd
}
