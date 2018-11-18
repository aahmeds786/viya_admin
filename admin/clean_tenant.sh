#!/bin/bash

#vwY1vWFVt6zx5hCFbPDKeyb9rLVzHKS

tenant_id=aero
perDatabase=0
perSchema=1
var=

if [ -z ${var+x} ]; then
echo var is not set
else 
echo var is set to ${var}
fi

if [ -z {$perDatabase+x} ]; then
  echo -e "Not set for perDatabase."
else
  delete from logon_provider.group_membership where member_id in (select id from logon_provider.users where identity_zone_id='${tenant_id}');
  delete from logon_provider.user_info where user_id in (select id from logon_provider.users where identity_zone_id='${tenant_id}');
  delete from logon_provider.users where identity_zone_id='tenantID';
  delete from logon_provider.group_membership where group_id in (select id from logon_provider.groups where identity_zone_id='${tenant_id}');
  delete from logon_provider.groups where identity_zone_id='${tenant_id}';
  delete from logon_provider.identity_provider where identity_zone_id='${tenant_id}';
  delete from logon_provider.identity_zone where name='${tenant_id}';
fi


if [ -z ${perSchema+x} ]; then
  echo -e "Not set for perSchema."
else
  delete from logon.group_membership where member_id in (select id from logon.users where identity_zone_id='aero');
  delete from logon.user_info where user_id in (select id from logon.users where identity_zone_id='aero');
  delete from logon.users where identity_zone_id='aero';
  delete from logon.group_membership where group_id in (select id from logon.groups where identity_zone_id='aero');
  delete from logon.groups where identity_zone_id='aero';
  delete from logon.identity_provider where identity_zone_id='aero';
  delete from logon.identity_zone where name='aero';
fi
