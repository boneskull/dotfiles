# zshrc for darwin

function setup_homebrew {
  local HOMEBREW_PREFIX="${1}"
  # setup for brew-file
  if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    trysource "${HOMEBREW_PREFIX}/etc/brew-wrap"
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    echo "HOMEBREW_PREFIX is not set! Skipping Homebrew setup." >&2
  fi
}

# initialize z
function setup_z {
  local HOMEBREW_PREFIX="${1}"
  if [[ -n "${HOMEBREW_PREFIX}" ]]; then
    trysource "${1}/etc/profile.d/z.sh"
  else
    echo "HOMEBREW_PREFIX is not set! Skipping z setup." >&2
  fi
}

(( $+commands[brew] )) && setup_homebrew "$(brew --prefix)"
(( $+commands[z] )) && setup_z "$(brew --prefix)"

# https://stackoverflow.com/questions/45004352/error-enfile-file-table-overflow-scandir-while-run-reaction-on-mac
#
# may need to run this as root:
#
# echo kern.maxfiles=524288 | sudo tee -a /etc/sysctl.conf
# echo kern.maxfilesperproc=524288 | sudo tee -a /etc/sysctl.conf
# sudo sysctl -w kern.maxfiles=524288
# sudo sysctl -w kern.maxfilesperproc=524288

# ¯\_(ツ)_/¯
ulimit -n unlimited
