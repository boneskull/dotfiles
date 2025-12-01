# macOS-specific aliases

# Man pages to Dash (if installed)
is-app-installed Dash && {
  dash_man() {
    /usr/bin/open "dash://?query=manpages:$(omz_urlencode ${@})"
  }
  alias man=dash_man
}

# VS Code shortcut
(( $+commands[code] )) && {
  alias c=code
}
