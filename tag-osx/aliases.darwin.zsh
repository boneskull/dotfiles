# SourceTree
which stree >/dev/null && alias st="/usr/bin/env stree"

# Man pages to Dash
[[ -n $(mdfind "kMDItemFSName == 'Dash.app'" | head -n1) ]] && {
  dash_man() {
    /usr/bin/open "dash://manpages:$(omz_urlencode ${@})"
  }

  alias man=dash_man
}
