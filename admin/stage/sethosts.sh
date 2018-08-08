#!/bin/bash

# Sets the hostname and binds it to the external IP

# --------------------------------------------------------
# Static Variables
# --------------------------------------------------------

GVERR=${RED}ERROR:${NORM}
VIP=`ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}'`
# --------------------------------------------------------

function stdchk() {

if [ $? -ne 0 ]; then
  printf "${_VHEAD} \t${GVERR}  Execution failed, check to make sure you have sudo or root privileges.\n\n"
  exit 1
else
  printf "${_VHEAD} \t${MSG}\n"
fi
}

echo "${VIP}    ${_LHOST} ${_SHOST}" | sudo tee -a /etc/hosts 1>&2
MSG="System hosts file was updated successfully."
stdchk

sudo hostnamectl set-hostname ${_LHOST}
MSG="System host name was updated successfully."
stdchk
