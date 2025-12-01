# extglob support
setopt extendedglob

# Helper for OS-specific sourcing using $OSTYPE
source-for-os() {
  local base="${1}"
  case "$OSTYPE" in
    darwin*)  trysource "${base}.darwin.zsh" ;;
    linux*)   trysource "${base}.linux.zsh" ;;
  esac
}

source "${HOME}/.functions.zsh"
source-for-os "${HOME}/.functions"

source "${HOME}/.exports.zsh"
source-for-os "${HOME}/.exports"

source "${HOME}/.antigen.zsh"
source-for-os "${HOME}/.antigen"

source "${HOME}/.aliases.zsh"
source-for-os "${HOME}/.aliases"

source "${HOME}/.completions.zsh"
source-for-os "${HOME}/.completions"

source-for-os "${HOME}/.zshrc"

export PATH="${PATH}:./node_modules/.bin"

trysource "${HOME}/.extra.zsh"
