#!/bin/bash

# Sets the hostname and binds it to the external IP

# Change this variable to set your own hostname
LHOST=vi.aws.local
SHOST=vi

# --------------------------------------------------------
# Static Variables
# --------------------------------------------------------

VC=$(tput setaf 45)
RED=$(tput setaf 1)
NORM=$(tput sgr0)

HEAD="[ ${VC}SAS VIYA${NORM} ]"
GVERR=${RED}ERROR:${NORM}
VIP=`ip addr show eth0 | awk '$1 == "inet" {gsub(/\/.*$/, "", $2); print $2}'`
# --------------------------------------------------------

function stdchk() {

if [ $? -ne 0 ]; then
  printf "${HEAD} \t${GVERR}  Execution failed, check to make sure you have sudo or root privileges.\n\n"
  exit 1
else
  printf "${HEAD} \t${MSG}\n"
fi
}


echo "${VIP}    ${LHOST} ${SHOST}" | sudo tee -a /etc/hosts 1>&2
MSG="System hosts file was updated successfully."
stdchk

