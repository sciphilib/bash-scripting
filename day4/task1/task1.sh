#!/bin/bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
SCRIPT_NAME=$(basename -- "${BASH_SOURCE[0]}")

set -e

echo "This script backs up the data file to destination."
read -p "Enter the data which need to copy: " data
read -p "Enter the destination directory: " dest
read -p "Enter the utility that will perform the copying (tar or dd): " util

[[ ! -e "${dest}" ]] && mkdir -p "${dest}"
filename=$(echo "${data}" | awk -F / '{print $NF}')
if [[ $util = "tar" ]] ; then 
    tar -cf "${dest}"/"${filename}.tar" "${data}"
elif [[ $util = "dd" ]] ; then
    echo "Enter the size of one block for write and read at a time."
    read -p "It is the number with the following multiplicative suffixes (c, kB, K, MB, GB, G etc.). Example: 1b: " bytes
    read -p "Enter the count of blocks (can skip if want to): " blocks
    if [[ -z ${blocks} ]] ; then
	dd if="${data}" of="${dest}"/"${filename}" bs=${bytes:=512} 
    else
	dd if="${data}" of="${dest}"/"${filename}" bs=${bytes:=512} count=blocks
    fi
else
    echo "Error: you entered: ${util}. Try again."
fi

read -p "Save the changes in the remote github repository? (y/n): " answer
if [[ ${answer} = "y" ]] ; then
    output=$(find "${dest}" -name ".git" | wc -l)
    cd "${dest}"
    [[ $output -eq 0 ]] && git init &>/dev/null
    [[ $(git remote | wc  -l) -eq 0 ]] && { read -p "Enter the remote rep URL: " url; git remote add origin "${url}"; }
    if [[ -n "$(git status --porcelain)" ]] ; then
	git add *
	git commit -m "backup $(date '+%d-%m-%y %H:%M')"
    else
	echo "There are no changes to save."
    fi
    git push -u origin master
fi

read -p "Should this script be run on a schedule? (y/n): " schedule
if [[ ${schedule} = "y" ]] ; then
    printf "1. Every n minutes.\n2. Every n hours.\n3. Every n days.\n"
    read -p "Enter the item (1-3): " choose
    if [[ 1 -le ${choose} ]] && [[ ${choose} -le 3 ]] ; then
     	[[ $choose -eq 1 ]] && { read -p "Enter the number of minutes: " min; cronrow="*/${min} * * * * ${USER} ${SCRIPT_DIR}/${SCRIPT_NAME}"; }
	[[ $choose -eq 2 ]] && { read -p "Enter the number of hours: " hrs; cronrow="* */${hrs} * * * ${USER} ${SCRIPT_DIR}/${SCRIPT_NAME}"; }
	[[ $choose -eq 3 ]] && { read -p "Enter the number of days: " days; cronrow="* * */${days} * * ${USER} ${SCRIPT_DIR}/${SCRIPT_NAME}"; }
	crontab -l | { cat; echo "${cronrow}"; } | crontab -  
    else
     	printf "Incorrect argument. Try again."
    fi 
fi

