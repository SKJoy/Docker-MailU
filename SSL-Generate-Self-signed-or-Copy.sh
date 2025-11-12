#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
bash ${THIS_SCRIPT_PATH}SSL-Generate-Self-signed.sh
bash ${THIS_SCRIPT_PATH}SSL-Copy.sh

# cat <<CONTENT

# ⭐ SSL certificate copied over
#    ❓ Source        : '${SOURCE_PATH}'
#    ❓ Path        : '${TARGET_PATH}'
#    ⏰ Time        : ${CURRENT_DATE} ${CURRENT_TIME}

# CONTENT