#!/bin/bash
#===========================================================================================================
#
#          SCRIPT: cleanAuditOpsContentsh
#     DESCRIPTION: Delete physical audit content on all Viya deployment hosts.
#
#           USAGE: realLDAPprop.sh
#
#===========================================================================================================
#
cd /root/sas_viya_playbook/

printf "${_VHEAD} \t --- Processing... -------------------------------------------------------"
ansible Operations -b --become-method=sudo -m shell -a '/bin/rm -fR /opt/sas/viya/config/var/cache/auditcli/*'
