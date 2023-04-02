#!/bin/bash

[[ $# -lt 2 ]] && echo "Enter the name of the file to be produced and the time at which it will be run."

echo "ffplay \"${1}\"" | at "$2"

