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
USER=$2
PASSWORD=$3
QUOTA=$4
COMMENT=$5
FORWARD_EMAIL=$6
SPAM_DETECTION=$7
DISPLAY_NAME=$8

if [[ -z "${FORWARD_EMAIL}" ]]; then
  ENABLE_FORWARD=false
  FORWARD_NODE_NAME_SUFFIX="-disabled"
else
  ENABLE_FORWARD=true
  FORWARD_NODE_NAME_SUFFIX=
fi

bash Domain-create.sh $DOMAIN false

curl -d "{\"email\": \"${USER}@${DOMAIN}\",\"raw_password\": \"${PASSWORD}\",\"quota_bytes\": ${QUOTA:-3221225472},\"comment\": \"${COMMENT:-}\",\"displayed_name\": \"${DISPLAY_NAME:-}\",\"spam_enabled\": ${SPAM_DETECTION:-false},\"forward_enabled\": ${ENABLE_FORWARD:-false},\"forward_destination${FORWARD_NODE_NAME_SUFFIX}\": [\"${FORWARD_EMAIL:-}\"],\"forward_keep\": true,\"change_pw_next_login\": false,\"allow_spoofing\": false}" "${MAILU_URL}${MAILU_URL_PREFIX_API}/v1/user" -X "POST" -H "Authorization: ${MAILU_API_TOKEN}" -H "Content-Type: application/json" -sS

cat <<CONTENT

Syntax: bash User-create.sh DOMAIN USER PASSWORD QUOTA_BYTES COMMENT FORWARD_EMAIL SPAM_DETECTION DISPLAY_NAME
	- DOMAIN: STRING = mydomain.com
	- USER: STRING = myname
	- PASSWORD: STRING = "super\"strong\"password"
	- QUOTA_BYTES: INTEGER = 3221225472 (3GB)
	- COMMENT: STRING = "This is a \" double quoted comment"
	- FORWARD_EMAIL: STRING = another@emailaddress.com
	- SPAM_DETECTION: BOOLEAN = true|false
	- DISPLAY_NAME: STRING = "Humanly name with double \" quote within"

CONTENT

