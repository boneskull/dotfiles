[[ -d /opt/X11/ ]] && {
  export PATH="/opt/X11/bin:${PATH}"
}

[[ -d /Applications/Server.app/ ]] && {
  export PATH="/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:${PATH}"
}

[[ $(get_env homebrew) ]] && {
  [[ -d $(brew --prefix)/share/antigen/ ]] && {
    export ANTIGEN_HOME="$(brew --prefix)/share/antigen/"
  }
  [[ -d /usr/local/share/zsh/help ]] && {
    export HELPDIR=/usr/local/share/zsh/help
  }
  export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications";
  export HOMEBREW_BREWFILE="${HOME}/.Brewfile"
}
