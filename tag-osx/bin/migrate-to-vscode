#!/bin/bash

VSCODE_ID="com.microsoft.VSCode"
CURSOR_ID=$(osascript -e 'id of app "Cursor"')

echo "VS Code Bundle ID: $VSCODE_ID"
echo "Cursor Bundle ID: $CURSOR_ID"
echo "Finding extensions bound to Cursor and rebinding to VS Code..."
echo ""

# Common file extensions to check
extensions=(
  js ts tsx jsx json jsonc yaml yml md markdown
  css scss sass less html htm xml svg
  sh bash zsh fish py pyc pyw
  rb erb gemspec rake
  go mod sum
  rs toml
  c cpp cxx cc h hpp hxx hh
  swift java kt kts
  sql db sqlite
  txt log conf ini env
  mjs cjs
  vue svelte astro
  php phtml
  pl pm
  lua r dart sol
  graphql gql
  proto
  diff patch
  properties gitignore dockerignore
)

count=0

for ext in "${extensions[@]}"; do
  # Get current handler (3rd line is bundle ID)
  current=$(duti -x "$ext" 2>/dev/null | sed -n '3p')

  if [ "$current" = "$CURSOR_ID" ]; then
    echo "✓ Rebinding .$ext: $CURSOR_ID -> $VSCODE_ID"
    duti -s "$VSCODE_ID" ".$ext" all
    ((count++))
  fi
done

echo ""
if [ $count -eq 0 ]; then
  echo "No extensions found bound to Cursor."
else
  echo "Migration complete! Rebound $count extensions from Cursor to VS Code."
fi