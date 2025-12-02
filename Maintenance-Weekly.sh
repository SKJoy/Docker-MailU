#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
bash Maintenance-Daily.sh
bash Backup.sh
bash Backup-Prune.sh

echo "${CURRENT_DATE} ${CURRENT_TIME} Weekly maintenance task completed" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Weekly maintenance task
   ✅ Backup
   ✅ Backup prune
   ❓ Path		: '${THIS_SCRIPT_PATH}'
   ⏰ Time		: ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT


