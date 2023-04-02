#!/bin/bash

ARGS=2
E_BADARGS=85
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
SCRIPT_NAME=$(basename -- "${BASH_SOURCE[0]}")
FILE="${SCRIPT_DIR}"/"$2"

if [[ $# -ne "$ARGS" ]]; then
    echo "Usage: $(basename $0) at/cron filename"
    exit $E_BADARGS
fi

[[ ! -e "${FILE}" ]] && touch "${FILE}"
count=$(wc -l "${FILE}" | awk '{print $1 + 1}')
echo "$(date '+%H:%M') I run $count times" >> "${FILE}"

if [[ $1 == "at" ]]; then
    echo /."${SCRIPT_DIR}"/"${SCRIPT_NAME}" $1 $2 | at now +1 minutes
elif [[ $1 == "cron" && $count -eq 1 ]]; then
    crontab -l | { cat; echo "* * * * * "${SCRIPT_DIR}"/"${SCRIPT_NAME}" "$1" "$2""; } | crontab -
fi

