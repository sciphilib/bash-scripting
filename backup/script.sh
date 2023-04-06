#!/bin/bash

E_BADARGS=85
if [[ $# -ne  1 ]]; then
	echo "Script usage: $(basename $0) /path-to-dir/"
	echo "/path-to-dir/ -- directory in which to make a backup"
	exit $E_BADARGS
fi

SRC="$1"
LIST_DIR=/home/"${USER}"
BACKUP_DATE_FILE="${LIST_DIR}"/backup
BACKUP_LIST=/tmp/"${USER}"_$(date  +%d-%m-%Y)_$(date +%H-%M).txt
SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
SCRIPT_NAME=$(basename -- "${BASH_SOURCE[0]}")
FIRST_BACKUP=0

[[ ! -s "${BACKUP_DATE_FILE}" ]] && { date > "${BACKUP_DATE_FILE}"; FIRST_BACKUP=1; }
LAST_BACKUP_DATE=$(cat "${BACKUP_DATE_FILE}")

touch "${BACKUP_LIST}"

for file in $(find "${SRC}"); do
	[[ $(echo "${file}" | grep "^"${SRC}"$" | wc -l) -eq 1 ]] && continue
	FILE_MOD_TIME=$(date -r "${file}")
	if [[ ${FIRST_BACKUP} -eq 1 || "$LAST_BACKUP_DATE" < "$FILE_MOD_TIME" ]];  then
		echo "${file}" >> "${BACKUP_LIST}"
	fi
done

date > "${BACKUP_DATE_FILE}"
[[ -s "${BACKUP_LIST}" ]] && echo | mail -a "${BACKUP_LIST}" -s "Fresh backup" "${USER}"
[[ -e "${BACKUP_LIST}" ]] && rm "${BACKUP_LIST}"

CRONEX=$(crontab -l | grep "/home/"${USER}"/"${SCRIPT_NAME}" "${SRC}"" | wc -l)
if [[ $CRONEX -eq 0 ]]; then
	CRONROW="*/1 * * * * "${SCRIPT_DIR}"/"${SCRIPT_NAME}" "${SRC}""
	crontab -l | { cat; echo "${CRONROW}"; } | crontab -
fi
