
# SourceTree
whence stree >/dev/null && alias st="/usr/bin/env stree"

# Atom
[[ ${EDITOR} == atom ]] && alias a="/usr/bin/env atom"

whence rcup >/dev/null && {
  alias rcup="rcup -t app git osx"
  alias lsrc="lsrc -t app git osx"
}
