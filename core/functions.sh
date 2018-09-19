#!/bin/bash
#===========================================================================================================
#
#          SCRIPT: functions.sh
#     DESCRIPTION: This is a core script used to fascilitate functions for global use.
#
#           USAGE: To be sourced.
#
#===========================================================================================================

## Downloads and uppacks the latest RPM

download_and_unpackage_latest_rpm() {
    url=$1
    package_name=$2
    rpm_package=$(curl -s -k ${url} | grep ${package_name} | sed 's/<.*>\(sas[^<>]*\)<.*/\1/' | sort | tail -1)
    curl -O -k ${url}${rpm_package}
    rpm2cpio ${rpm_package} | cpio -ivd
}

# ----------------------------------
# ---- Get a value from the kv -----
# ----------------------------------

GetConsulKV()
{
   local KEY="$1"
   ${SASHome}/bin/sas-bootstrap-config  read "$KEY"
}

## Insert a value to the kv
InsertKV()
{
   Key="$1"
   Value="$2"
   $SASHome/bin/sas-bootstrap-config kv write --force -- "$Key" "$Value"
}

## Delete a value from the kv
DeleteConsul()
{
   local KEY=$1
   $SASHome/bin/sas-bootstrap-config kv delete --recurse --prefix "$KEY"
}

quit()
{
   if [ $# -gt 0 ] ; then
      echo "$1"
      [ $# -gt 1 ] && exit $2
   fi
   exit 0
}


if [ $no ]; then
/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/postgres/host
/opt/sas/viya/home/bin/sas-bootstrap-config kv read config/application/postgres/port
fi

