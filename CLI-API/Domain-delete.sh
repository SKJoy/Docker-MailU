#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
source ../.env

DOMAIN=$1

curl "${MAILU_URL}${MAILU_URL_PREFIX_API}/v1/domain/${DOMAIN}" -X "DELETE" -H "Authorization: ${MAILU_API_TOKEN}" -H "Content-Type: application/json" -sS

cat <<CONTENT

Syntax: bash Domain-delete.sh DOMAIN
	- DOMAIN: STRING = mydomain.tld

CONTENT

