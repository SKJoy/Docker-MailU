#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
bash SSL-Copy.sh
bash Recreate.sh

echo "${CURRENT_DATE} ${CURRENT_TIME} Daily maintenance task completed" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Daily maintenance task
   ✅ Copy SSL certificate
   ✅ Recreate Docker stack
   ❓ Path		: '${THIS_SCRIPT_PATH}'
   ⏰ Time		: ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT


