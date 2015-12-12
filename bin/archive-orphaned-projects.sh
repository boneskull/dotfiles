#!/bin/bash

DIR=${1}
BACKUP_DIR=/Volumes/alien/projects/archive/

function archive {
  local DIRS=$@

  for DIR in ${DIRS}
  do
    if [[ -d ${DIR} ]]
    then
      if [[ -e ${DIR}/package.json ]]
      then
        echo "Archiving npm module ${DIR}..."
        mv "${DIR}" "${BACKUP_DIR}" && cd "${BACKUP_DIR}" && npm pack "${DIR}" && rm -frv "${DIR}" && cd - >/dev/null
      else
        echo "Archiving ${DIR}..."
        local DATE=`slug "$(date '+%Y-%m-%d %H:%M:%S')"`
        tar cvzf "${BACKUP_DIR}/`slug ${DIR}`-${DATE}.tar.gz" ${DIR} && rm -frv "${DIR}"
      fi
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
