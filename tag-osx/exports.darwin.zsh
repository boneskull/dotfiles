[[ -d /opt/X11/ ]] && {
  export PATH="/opt/X11/bin:${PATH}"
}

[[ $(get-env homebrew) ]] && {
  [[ -d $(get-env homebrew)/share/antigen/ ]] && {
    export ANTIGEN_HOME="$(get-env homebrew)/share/antigen/"
  }
  [[ -d $(get-env homebrew)/share/zsh/help ]] && {
    export HELPDIR=$(get-env homebrew)/share/zsh/help
  }

  set-env-flag-if-executable "brew" "homebrew"

  # leaving this enabled makes everything slow af
  export HOMEBREW_NO_INSTALL_CLEANUP=1

  # setup for nvm and homebrew
  [ -s "$(get-env homebrew)/opt/nvm/nvm.sh" ] && \. "$(get-env homebrew)/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "$(get-env homebrew)/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$(get-env homebrew)/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
}

# uncomment if ruby needed?
# [[ -d /usr/local/opt/ruby/bin ]] && {
#   export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:${PATH}"
#   export LDFLAGS="-L/usr/local/opt/ruby/lib"
#   export CPPFLAGS="-I/usr/local/opt/ruby/include"
#   export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"
# }

# Always enable colored `grep` output (bsd grep, I guess)
export GREP_OPTIONS="--color=auto"

[[ -d ${HOME}/Library/Android ]] && {
  # for android sdk
  export ANDROID_HOME="${HOME}/Library/Android/sdk"
}
