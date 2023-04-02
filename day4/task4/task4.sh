#!/bin/bash

pids=($(pidof systemd))
ps -fe | head -1
for i in ${pids[@]}; do
    ps -fe | awk -v pid=$i '{if($3 == pid){{print $0}}}'
done

