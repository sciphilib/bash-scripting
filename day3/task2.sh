#!/bin/bash

default_dir_path=./
default_dir_pattern=dir
default_file_pattern=file

dirs_path=${1:-$default_dir_path}
dir1_count=${2:-3}
dir2_count=${3:-5}
dir3_count=${4:-3}
dir1_pattern=${5:-$default_dir_pattern}
dir2_pattern=${6:-$default_dir_pattern}
file_pattern=${7:-$default_file_pattern}

for (( i=0; i<dir1_count; i++ ))
do
    mkdir ${dirs_path}/${dir1_pattern}_$i
    for (( j=0; j<dir2_count; j++ ))
    do
	mkdir ${dirs_path}/${dir1_pattern}_$i/${dir2_pattern}_$j
	for (( k=0; k<dir3_count; k++ ))
	do
	    touch ${dirs_path}/${dir1_pattern}_$i/${dir2_pattern}_$j/${file_pattern}_$k
	done
    done
done

