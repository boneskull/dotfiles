[[ -d /opt/X11/ ]] && {
  export PATH="/opt/X11/bin:${PATH}"
}

[[ -d /Applications/Server.app/ ]] && {
  # importantly, don't override homebrew with this crap
  export PATH="${PATH}:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:"
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

export PATH="/usr/local/opt/python/libexec/bin:${PATH}"
