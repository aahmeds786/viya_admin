## Ready Variables for bootstrap
. /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/management.token) 

#Read the properties from identies
echo
echo Connection Properties
/opt/sas/viya/home/bin/sas-bootstrap-config  kv read --recurse config/identities/sas.identities.providers.ldap.connection/host
/opt/sas/viya/home/bin/sas-bootstrap-config  kv read --recurse config/identities/sas.identities.providers.ldap.connection/port
/opt/sas/viya/home/bin/sas-bootstrap-config  kv read --recurse config/identities/sas.identities.providers.ldap.connection/userDN
/opt/sas/viya/home/bin/sas-bootstrap-config  kv read --recurse config/identities/sas.identities.providers.ldap.connection/password
echo
echo Group baseDN Property
/opt/sas/viya/home/bin/sas-bootstrap-config  kv read --recurse config/identities/sas.identities.providers.ldap.group/baseDN
echo
echo User baseDN Property
/opt/sas/viya/home/bin/sas-bootstrap-config  kv read --recurse config/identities/sas.identities.providers.ldap.user/baseDN

 

