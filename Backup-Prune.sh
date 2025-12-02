#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
BACKUP_PATH="Backup"
BACKUP_EXTENSION="zip"
BACKUP_AGE_DAY="+30"
find "${BACKUP_PATH}" -type f -name "*.${BACKUP_EXTENSION}" -mtime "${BACKUP_AGE_DAY}" -exec rm {} \;

echo "${CURRENT_DATE} ${CURRENT_TIME} Backup pruned" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Prune old backup
   ❓ Age		: ${BACKUP_AGE_DAY} day
   ❓ Path		: '${THIS_SCRIPT_PATH}/${BACKUP_PATH}/*.${BACKUP_EXTENSION}'
   ⏰ Time		: ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT


