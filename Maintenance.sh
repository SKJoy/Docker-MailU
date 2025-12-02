#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
# bash Log-Clear.sh
bash SSL-Copy.sh

DAY_OF_MONTH=$(date +%d);
WEEK_RESULT=$((DAY_OF_MONTH % 7));

if [[ "${WEEK_RESULT}" == 0 ]]; then
	ACTION="Weekly backup and prune"
	bash Backup.sh
	bash Backup-Prune.sh
else
	ACTION="Daily restart with SSL copy"
	bash Recreate.sh
fi

echo "${CURRENT_DATE} ${CURRENT_TIME} Maintenance task completed" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Maintenance task
   ❓ Action		: '${ACTION}'
   ❓ Path		: '${THIS_SCRIPT_PATH}'
   ⏰ Time		: ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT


