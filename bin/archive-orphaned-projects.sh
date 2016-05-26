#!/bin/bash

set -e

DIR=${1}
BACKUP_DIR=/media/samara/Archives/
ARCHIVE="${HOME}/bin/archive"

function archive {
  local DIRS=$@

  for DIR in ${DIRS}
  do
    if [[ -d ${DIR} ]]
    then
      ${ARCHIVE} "${DIR}"
    else
      echo "Skipping non-directory ${DIR}..."
    fi
  done
}

echo "Checking projects in ${DIR}"
for FILE in ${DIR}/*
do
  if [[ -d ${FILE}/.git ]]
  then
    GIT_DIR="${FILE}/.git" git ls-remote > /dev/null 2>&1 || archive "${FILE}"
  else
    echo "${FILE} is not a git repository"
  fi
done
