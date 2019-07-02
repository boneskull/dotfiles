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

[[ $(get-env homebrew) ]] && {
  [[ -d $(brew --prefix)/share/antigen/ ]] && {
    export ANTIGEN_HOME="$(brew --prefix)/share/antigen/"
  }
  [[ -d $(brew --prefix)/share/zsh/help ]] && {
    export HELPDIR=$(brew --prefix)/share/zsh/help
  }
  export HOMEBREW_CASK_OPTS="--appdir=${HOME}/Applications"
  export HOMEBREW_BREWFILE="${HOME}/.Brewfile"
}

[[ $(get-env nnn) ]] && {
  export NNN_BMS="d:${HOME}/downloads;p:${HOME}/projects"
}

[[ -d ${HOME}/esp32 ]] && {
  export IDF_PATH="${HOME}/esp32/esp-idf"
  export PATH="${HOME}/esp32/xtensa-esp32-elf/bin:${MODDABLE}/build/bin/mac/release:$PATH"
  export UPLOAD_PORT="/dev/cu.SLAB_USBtoUART"
}

[[ -d ${HOME}/projects/moddable/moddable ]] && {
  export MODDABLE="${HOME}/projects/moddable/moddable"
}
