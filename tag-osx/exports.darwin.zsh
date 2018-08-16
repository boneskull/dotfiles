[[ -d /opt/X11/ ]] && {
  export PATH="/opt/X11/bin:${PATH}"
}

[[ -d /Applications/Server.app/ ]] && {
  # importantly, don't override homebrew with this crap
  export PATH="${PATH}:/Applications/Server.app/Contents/ServerRoot/usr/bin:/Applications/Server.app/Contents/ServerRoot/usr/sbin:"
}

[[ -d /usr/local/opt/ccache/libexec ]] && {
    export PATH="/usr/local/opt/ccache/libexec:${PATH}"
}

[[ $(get-env homebrew) ]] && {
  [[ -d $(brew --prefix)/share/antigen/ ]] && {
    export ANTIGEN_HOME="$(brew --prefix)/share/antigen/"
  }
  [[ -d $(brew --prefix)/share/zsh/help ]] && {
    export HELPDIR=$(brew --prefix)/share/zsh/help
  }
  export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications";
  export HOMEBREW_BREWFILE="${HOME}/.Brewfile"
}

