#!/bin/bash
#
# Find microservices issues
#
cd /root/sas_viya_playbook

echo 'List all Viya deployment hosts services that are not "UP"'
echo "---------------------------------------------------------"
ansible sas-all -m shell -a "service sas-viya-all-services status | grep -v ' up '"

