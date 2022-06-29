[[ -d /opt/X11/ ]] && {
  export PATH="/opt/X11/bin:${PATH}"
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

  set-env-flag-if-executable "brew" "homebrew"

  # setup for nvm and homebrew
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

# Always enable colored `grep` output (bsd grep, I guess)
export GREP_OPTIONS="--color=auto"

# for android sdk
export ANDROID_HOME="${HOME}/Library/Android/sdk"
