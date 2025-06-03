# Man pages to Dash
is-app-installed Dash && {
  dash_man() {
    /usr/bin/open "dash://?query=manpages:$(omz_urlencode ${@})"
  }

  alias man=dash_man
}

[[ $(get-env gls) ]] && {
  alias ls="gls --color"
}

is-app-installed 'Visual Studio Code' && {
  alias c=code
}
