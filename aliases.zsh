# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

# Hub
whence hub >/dev/null && alias git="/usr/bin/env hub"

