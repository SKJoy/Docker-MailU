#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
bash Maintenance-Daily.sh

DAY_OF_MONTH=$(date +%d);
WEEK_RESULT=$((DAY_OF_MONTH % 7));
MONTH_RESULT=$((DAY_OF_MONTH % 28));

if [[ "${MONTH_RESULT}" == 0 ]]; then
	ACTION="Monthly"
	bash Maintenance-Monthly.sh
elif [[ "${MONTH_RESULT}" == 0 ]]; then
	ACTION="Weekly"
	bash Maintenance-Weekly.sh
else
	ACTION="Daily"
fi


