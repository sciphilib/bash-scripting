#!/bin/bash

E_NO_ARGS=65

if [ $# -lt 2 ]
then
    echo "Please invoke this script with 2 command-line arguments: proccess and check time interval (since and until)."
    exit $E_NO_ARGS
fi

journalctl -u $1 --since $2 --until $3
