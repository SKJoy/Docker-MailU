#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
docker compose down
docker comppose up -d
echo "${CURRENT_DATE} ${CURRENT_TIME} Docker project recreated" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Project recreated
   ❓ Item
      ⚡ Log files
   ⏰ Time  : ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT