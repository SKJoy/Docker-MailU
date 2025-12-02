#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
BACKUP_PATH="${THIS_SCRIPT_PATH}Backup"
BACKUP_FILE="${BACKUP_PATH}/${CURRENT_DATE_TIME}.zip"

docker compose stop
# bash ${THIS_SCRIPT_PATH}Clean.sh
mkdir ${BACKUP_PATH} -p
echo "⭐ Backup in progress..."
echo "   ⏳ Please wait"
zip -r9q ${BACKUP_FILE} . -x Backup/\* && echo "   ✅ Successful" || echo "   ⭕ ERROR"
docker compose start
echo "${CURRENT_DATE} ${CURRENT_TIME} Docker project backed up to ${BACKUP_FILE}" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Docker project backed up
   ❓ Backup file	: '${BACKUP_FILE}'
   ❓ Path		: '${THIS_SCRIPT_PATH}'
   ⏰ Time		: ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT
