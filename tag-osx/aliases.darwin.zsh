# macOS-specific aliases

# Man pages to Dash (if installed)
if is-app-installed Dash; then
  function man {
    if [[ -t 1 ]]; then
      # Interactive terminal - use Dash
      /usr/bin/open "dash://manpages:${(j:%20:)@}"
    else
      # Piped/scripted - use real man
      command man "$@"
    fi
  }
fi
