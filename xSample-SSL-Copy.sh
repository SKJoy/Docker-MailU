#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# User customization
## SSL certificate source
SSL_SOURCE_PATH="/Docker/Project/Utility/Volume/NginX-Proxy-Manager/SSL/archive/npm-1"
SSL_SOURCE_CERTIFICATE_FILE="fullchain1.pem"
SSL_SOURCE_KEY_FILE="privkey1.pem"

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
MAILU_PATH="${THIS_SCRIPT_PATH}Volume/MailU/SSL"

mkdir ${MAILU_PATH} -p
cp -fv ${SSL_SOURCE_PATH}/fullchain1.pem ${MAILU_PATH}/cert.pem
cp -fv ${SSL_SOURCE_PATH}/privkey1.pem ${MAILU_PATH}/key.pem
docker compose restart
echo "${CURRENT_DATE} ${CURRENT_TIME} SSL certifiate copied from ${SSL_SOURCE_PATH}" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ SSL certificate copied over
   ❓ Source        : '${SSL_SOURCE_PATH}'
   ❓ Path        : '${MAILU_PATH}'
   ⏰ Time        : ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT