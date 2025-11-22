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
ALLOW_SIGNUP=$2
COMMENT=$3

curl -d "{\"name\": \"${DOMAIN}\",\"comment\": \"${COMMENT:-}\",\"signup_enabled\": ${ALLOW_SIGNUP:=false}}" "https://${HOST_NAME}${MAILU_URL_PREFIX_API}/v1/domain" -X "POST" -H "Authorization: ${MAILU_API_TOKEN}" -H "Content-Type: application/json" -sSf && curl "https://${HOST_NAME}${MAILU_URL_PREFIX_API}/v1/domain/${DOMAIN}/dkim" -X "POST" -H "Authorization: ${MAILU_API_TOKEN}" -H "Content-Type: application/json" -sS

cat <<CONTENT

Syntax: bash Domain-create.sh DOMAIN ALLOW_SIGNUP COMMENT
	- DOMAIN: STRING = mydomain.tld
	- ALLOW_SIGNUP: BOOLEAN = true|false
	- COMMENT: STRING = "This is a \" double quoted comment"

CONTENT

