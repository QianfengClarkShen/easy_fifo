#!/bin/bash
source config.mk
vivado -mode tcl -nolog -nojournal -source scripts/ip_package.tcl -tclargs $ip_name $part_name
rm -f *.log
