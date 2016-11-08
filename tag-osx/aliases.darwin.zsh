
# SourceTree
whence stree >/dev/null && alias st="/usr/bin/env stree"

# Atom
[[ ${EDITOR} == atom ]] && alias a="/usr/bin/env atom"

whence rcup >/dev/null && {
  alias rcup="rcup -t app git osx"
  alias lsrc="lsrc -t app git osx"
}

[[ -d /Applications/Dash.app || -d ${HOME}/Applications/Dash.app ]] && {
  # Man pages to Dash
  dash_man () {
    /usr/bin/open "dash://manpages:$(omz_urlencode ${@})"
  }

  alias man=dash_man
}

