#!/bin/bash

# System managed; jump to `# User customization` section instead
CURRENT_DATE="$(date +%Y-%m-%d)";
CURRENT_TIME="$(date +%H-%M-%S)";
CURRENT_DATE_TIME="${CURRENT_DATE}-${CURRENT_TIME}";

THIS_SCRIPT_PATH="$(dirname "$0")/"
cd ${THIS_SCRIPT_PATH};

# EVERYTHING BELOW IS AUTOMATED; DO NOT CHANGE
DAY_OF_MONTH=$(date +%d);
MONTH_RESULT=$((DAY_OF_MONTH % 28));
WEEK_RESULT=$((DAY_OF_MONTH % 7));

if [[ "${MONTH_RESULT}" == 0 ]]; then
	ACTION="Monthly"
	bash Maintenance-Monthly.sh
elif [[ "${WEEK_RESULT}" == 0 ]]; then
	ACTION="Weekly"
	bash Maintenance-Weekly.sh
else
	ACTION="Daily"
	bash Maintenance-Daily.sh
fi


