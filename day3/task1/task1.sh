#!/bin/bash

for (( i = 0; i < $1; i++ ))
do
    mkdir dir_$i
    for (( j = 0; j < $2; j++ ))
    do
	mkdir dir_$i/dir2_$j
	for (( k = 0; k < $3; k++ ))
	do
	    touch dir_$i/dir2_$j/file_$k
	done
    done
done
