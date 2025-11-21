#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
cd Volume/MailU
chown -R root:root Data
chown -R root:root DKIM
chown -R mail:mail Mail
cd ../..

bash Recreate.sh

echo "${CURRENT_DATE} ${CURRENT_TIME} File permission fixed" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ File permission fixed
   ❓ Item
      ⚡ Data
      ⚡ DKIM
      ⚡ Mail
   ⏰ Time  : ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT

