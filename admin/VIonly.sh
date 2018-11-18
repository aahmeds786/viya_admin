#!/bin/bash

## This script will set the variables needed for access to kv from the sas-bootstrap.

. /opt/sas/viya/config/consul.conf
export CONSUL_TOKEN=$(sudo cat /opt/sas/viya/config/etc/SASSecurityCertificateFramework/tokens/consul/default/management.token)

echo -e "Current settings:"
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/deployment/ev.metrics.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/sas.bootstrap.jobexecution.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/sas.bootstrap.jobs.enabled 
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/sas.bootstrap.report.definitions.enabled

/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/deployment/ev.metrics.enabled false
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/sas.bootstrap.jobexecution.enabled false
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/sas.bootstrap.jobs.enabled false
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/sas.bootstrap.report.definitions.enabled false

echo -e "New settings:"
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/deployment/ev.metrics.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/sas.bootstrap.jobexecution.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/sas.bootstrap.jobs.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/sas.bootstrap.report.definitions.enabled

config/application/tenants/aero/deployment/ev.metrics.enabled false

/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/tenants/aero/deployment/ev.metrics.enabled false
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/tenants/aero/sas.bootstrap.jobexecution.enabled false
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/tenants/aero/sas.bootstrap.jobs.enabled false
/opt/sas/viya/home/bin/sas-bootstrap-config kv write config/application/tenants/aero/sas.bootstrap.report.definitions.enabled false

/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/tenants/aero/deployment/ev.metrics.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/tenants/aero/sas.bootstrap.jobexecution.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/tenants/aero/sas.bootstrap.jobs.enabled
/opt/sas/viya/home/bin/sas-bootstrap-config kv read --recurse config/application/tenants/aero/sas.bootstrap.report.definitions.enabled
