#!/bin/bash
#===========================================================================================================
#
#          SCRIPT: checkSrvc.sh
#     DESCRIPTION: This script will poll services across all nodes in the inventory for a down status.
#
#           USAGE: checkSrvc.sh
#
#===========================================================================================================

cd /root/sas_viya_playbook

printf " ----------------------------------------------\n"
printf "\t -- Check Service Availability --\n"
printf " ----------------------------------------------\n"

ansible sas-all -b -m shell -a "service sas-viya-all-services status | grep -v ' up '"

