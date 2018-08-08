#!/bin/bash
#
# Delete physical audit content
#
cd /root/sas_viya_playbook/

echo "Delete physical audit content on all Viya deployment hosts"
echo "----------------------------------------------------------"
ansible Operations -m shell -a '/bin/rm -fR /opt/sas/viya/config/var/cache/auditcli/{.*,*}!(.|..)'
