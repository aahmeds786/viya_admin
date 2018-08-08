#!/bin/sh

. /opt/sas/viya/config/consul.conf

echo "sharedVault before"

/opt/sas/viya/home/bin/sas-bootstrap-config --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token kv read 'config/deploymentBackup/sas.deploymentbackup/sharedVault'

echo "Setting sharedVault"

/opt/sas/viya/home/bin/sas-bootstrap-config --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token kv write --force "config/deploymentBackup/sas.deploymentbackup/sharedVault" "/BackupCentral"

echo "sharedVault after"

/opt/sas/viya/home/bin/sas-bootstrap-config --token-file /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token kv read 'config/deploymentBackup/sas.deploymentbackup/sharedVault'