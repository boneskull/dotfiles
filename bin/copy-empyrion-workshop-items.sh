#!/bin/bash

set -e

# replace these w/ whatever is appropriate for your system.
# it's likely to be the same
C="/mnt/c"
SRC="${C}/Program Files (x86)/Steam/steamapps/workshop/content/383120"
DEST="${C}/Program Files (x86)/Steam/steamapps/common/Empyrion - Galactic Survival/Saves/Blueprints/76561198080011352"

for SRC_EPB in "${SRC}"/*/*.epb; do  
  # derive jpg filename from epb filename
  SRC_JPG="${SRC_EPB%.epb}.jpg" 

  BASE_EPB=$(basename "${SRC_EPB}") # foo.epb

  NAME="${BASE_EPB%.epb}" # foo

  TARGET_DIR="${DEST}/${NAME}" # $DEST/foo/
  TARGET_EPB="${TARGET_DIR}/${BASE_EPB}" # $DEST/foo/foo.epb

  mkdir -p "${TARGET_DIR}"

  # only copy if workshop file differs
  if ! cmp -s "${SRC_EPB}" "${TARGET_EPB}"; then
    cp -v "${SRC_EPB}" "${TARGET_EPB}"
  fi

  # check if jpg exists (it might not)
  if [[ -e ${SRC_JPG} ]]; then
    BASE_JPG=$(basename "${SRC_JPG}") # foo.jpg
    TARGET_JPG="${TARGET_DIR}/${BASE_JPG}" # $DEST/foo/foo.jpg

    if ! cmp -s "${SRC_JPG}" "${TARGET_JPG}"; then
      cp -v "${SRC_JPG}" "${TARGET_JPG}"
    fi
  else
    echo "${BASE_JPG} not found"
  fi
done
