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

[[ -d /usr/local/opt/ruby/bin ]] && {
  export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:${PATH}"
  export LDFLAGS="-L/usr/local/opt/ruby/lib"
  export CPPFLAGS="-I/usr/local/opt/ruby/include"
  export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
}

[[ -d /opt/homebrew ]] && {
  eval "$(/opt/homebrew/bin/brew shellenv)"
  [[ -d $(brew --prefix)/share/antigen/ ]] && {
    export ANTIGEN_HOME="$(brew --prefix)/share/antigen/"
  }
  [[ -d $(brew --prefix)/share/zsh/help ]] && {
    export HELPDIR=$(brew --prefix)/share/zsh/help
  }

[[ $(get-env nnn) ]] && {
  export NNN_BMS="d:${HOME}/downloads;p:${HOME}/projects"
}

# Always enable colored `grep` output (bsd grep, I guess)
export GREP_OPTIONS="--color=auto"

# for android sdk
export ANDROID_HOME="${HOME}/Library/Android/sdk"
