#!/bin/bash

config_file=config
source $config_file
E_NO_ARGS=65

journalctl -u $process_name --since $since --until $until
