#!/bin/bash
#===========================================================================================================
#
#          SCRIPT: setVault.sh
#     DESCRIPTION: Delete physical audit content on all Viya deployment hosts.
#
#           USAGE: setVault.sh
#
#===========================================================================================================
#

## Source for bootstrap
. /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

printf "${_VHEAD} \t --- Processing... -------------------------------------------------------"
printf "Current sharedVault setting in Consul: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read 'config/deploymentBackup/sas.deploymentbackup/sharedVault'

/opt/sas/viya/home/bin/sas-bootstrap-config kv write --force "config/deploymentBackup/sas.deploymentbackup/sharedVault" "/BackupCentral"

printf "New sharedVault setting in Consul: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read 'config/deploymentBackup/sas.deploymentbackup/sharedVault'
printf "${_VHEAD} \t --- Complete... -------------------------------------------------------"
