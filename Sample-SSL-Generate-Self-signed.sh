#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# User customization
DOMAIN="domain.tld"

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
source .env
MAILU_PATH="${THIS_SCRIPT_PATH}Volume/MailU/SSL/"

mkdir ${MAILU_PATH} -p
openssl req -x509 -newkey rsa:4096 -keyout ${MAILU_PATH}key.pem -out ${MAILU_PATH}cert.pem -sha256 -days 3650 -nodes -subj "/CN=${DOMAIN}" -addext "subjectAltName=DNS:*.${DOMAIN}"
docker compose restart
echo "${CURRENT_DATE} ${CURRENT_TIME} Self signed SSL generated for ${DOMAIN}" >> ${THIS_SCRIPT_PATH}Action.log

cat <<CONTENT

⭐ Self signed SSL certificate generated
   ❓ Domain        : '${DOMAIN}'
   ❓ SAN        : '*.${DOMAIN}'
   ❓ Path        : '${MAILU_PATH}'
   ⏰ Time        : ${CURRENT_DATE} ${CURRENT_TIME}

CONTENT