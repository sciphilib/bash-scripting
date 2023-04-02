#!/bin/bash

E_NO_ARGS=65

if [ $# -lt 2 ]
then
    echo "Please invoke this script with 2 command-line arguments: process name and frequency of checking in minutes."
    exit $E_NO_ARGS
fi

ps_name=$1
checking_time=$2

while :
do

pidno=$(pidof $ps_name)

if [ -z "$pidno" ]
then
    echo "Run $ps_name."
    $ps_name
else
    echo "$ps_name is already running."; echo
    echo $pidno
fi
echo "Frequency of checking is $2 minute(s)"
sleep ${checking_time}s 
done
