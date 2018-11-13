#!/bin/bash
#===========================================================================================================
#
#          SCRIPT: readLDAPprop.sh
#     DESCRIPTION: This script will read the LDAP properties from Consul.
#
#           USAGE: realLDAPprop.sh
#
#===========================================================================================================

## Source for bootstrap
. /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

printf " ----------------------------------------------\n"
printf "\t -- Consul LDAP Properties Script --\n"
printf " ----------------------------------------------\n"

echo
printf "${_VHEAD} \t Connection Properties \n"
printf " - Hostname: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.connection/host
printf " - Port: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.connection/port
printf " - Connection BaseDN: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.connection/userDN
printf " - Password: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.connection/password
printf " - URL Connection: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.connection/url

printf " - Group BaseDN: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.group/baseDN
printf " - Group Account ID: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.group/accountId
printf " - Group Object Filter: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.group/objectFilter


printf " - User BaseDN: "
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.user/baseDN
# User Account ID
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.user/accountId
# User Object Filter
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/identities/sas.identities.providers.ldap.user/objectFilter
