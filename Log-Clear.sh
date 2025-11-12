#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
FILE_SIZE=0
truncate -s${FILE_SIZE} *.log
echo "${CURRENT_DATE} ${CURRENT_TIME} log files truncated" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Log file(s) truncated
   ❓ File size   : ${FILE_SIZE} byte(s)
   ❓ Item
      ⚡ Action
   ❓ Path        : '${THIS_SCRIPT_PATH}'
   ⏰ Time        : ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT