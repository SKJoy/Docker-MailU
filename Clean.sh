#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
bash ${THIS_SCRIPT_PATH}Log-Clear.sh
bash Backup-Prune.sh
# Other clean up job
# Other clean up job

echo "${CURRENT_DATE} ${CURRENT_TIME} System cleaned up" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Clean up complete
   ✅ Clear log
   ✅ Prune old backup
   ❓ Path		: '${THIS_SCRIPT_PATH}'
   ⏰ Time  : ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT