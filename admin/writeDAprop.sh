#!/bin/bash

. /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)

##Connection information
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.connection/host vi105.aws.com
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.connection/port 389
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.connection/password progress
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.connection/userDN cn=admin,dc=aws,dc=com
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.connection/url ldap://viya.aws.com:389

/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.group/accountId cn
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.group/baseDN dc=aws,dc=com
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.group/objectFilter "(objectClass=*)
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.user/groupsearchFilter (&(cn=*)(objectClass=*))

/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.user/accountId uid
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.user/baseDN dc=aws,dc=com
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.user/objectFilter (objectClass=inetOrgPerson)
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/identities/sas.identities.providers.ldap.user/usersearchFilter (&(uid=*)(objectClass=inetOrgPerson))

