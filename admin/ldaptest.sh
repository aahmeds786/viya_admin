#!/bin/bash
. /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/client.token)


file="SASViyaIdentitiesTest.properties"

if [ -f "$file" ]
then
  echo "$file found."

  while IFS='=' read -r key value
  do
    key=$(echo $key | tr '.' '_')
    eval ${key}=\${value}
  done < "$file"
  echo ""
  echo "Using values $file..."
    echo ""
  echo "Hostname           = " ${hostname}
  echo "Port               = " ${port}
  echo "password           = " ${password}
  echo "connection_baseDN  = " ${connection_baseDN}
  echo "urlConnection      = " ${urlConnection}
  echo "urlProtocol        = " ${urlProtocol}
  echo "groupaccountId     = " ${groupaccountId}
  echo "group_baseDN       = " ${group_baseDN}
  echo "groupobjectFilter  = " ${groupobjectFilter}
  echo "groupsearchFilter  = " ${groupsearchFilter}
  echo "useraccountId      = " ${useraccountId}
  echo "user_baseDN        = " ${user_baseDN}
  echo "userobjectFilter   = " ${userobjectFilter}
  echo "usersearchFilter   = " ${usersearchFilter}

else
  echo "$file not found."
  echo ""
  echo "Reading values from SAS Configuration Server..."
    echo ""
    ##Connection information
    hostname="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.connection/host)"
    port="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.connection/port)"
    password="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.connection/password)"
    connection_baseDN="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.connection/userDN)"
    urlConnection="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.connection/url)"
    urlProtocol=$(echo $urlConnection| cut -d":" -f 1)

    groupaccountId="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.group/accountId)"
    group_baseDN="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.group/baseDN)"
    groupobjectFilter="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.group/objectFilter)"
   groupsearchFilter="(&("$groupaccountId"=*)"$groupobjectFilter")"

    useraccountId="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.user/accountId)"
    user_baseDN="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.user/baseDN)"
    userobjectFilter="$(. /opt/sas/viya/config/consul.conf && /opt/sas/viya/home/bin/sas-bootstrap-config kv read config/identities/sas.identities.providers.ldap.user/objectFilter)"
    usersearchFilter="(&("$useraccountId"=*)"$userobjectFilter")"

    echo ""
    echo "Create $file..."
    echo ""
  echo "hostname=$hostname" > SASViyaIdentitiesTest.properties
  echo "port=$port" >> SASViyaIdentitiesTest.properties
  echo "password=$password" >> SASViyaIdentitiesTest.properties
  echo "connection_baseDN=$connection_baseDN" >> SASViyaIdentitiesTest.properties
  echo "urlConnection=$urlConnection" >> SASViyaIdentitiesTest.properties
  echo "urlProtocol=$urlProtocol" >> SASViyaIdentitiesTest.properties
  echo "groupaccountId=$groupaccountId" >> SASViyaIdentitiesTest.properties
  echo "group_baseDN=$group_baseDN" >> SASViyaIdentitiesTest.properties
  echo "groupobjectFilter=$groupobjectFilter" >> SASViyaIdentitiesTest.properties
  echo "groupsearchFilter=$groupsearchFilter" >> SASViyaIdentitiesTest.properties
  echo "useraccountId=$useraccountId" >> SASViyaIdentitiesTest.properties
  echo "user_baseDN=$user_baseDN" >> SASViyaIdentitiesTest.properties
  echo "userobjectFilter=$userobjectFilter" >> SASViyaIdentitiesTest.properties
  echo "usersearchFilter=$usersearchFilter" >> SASViyaIdentitiesTest.properties

fi

