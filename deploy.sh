#!/bin/sh
# ------------------------------------------------
# Author: ninewb
# ------------------------------------------------
# - This script is setup as the deploy
# - easy button.
#
# - Script assumes ./core/profile is sourced
#
#  TODO: add data connector, post-install, decision
#  tree to change few options
# ------------------------------------------------

_CLEAN=N

function err() {
if [ $? -ne 0 ]; then
  printf "${_VHEAD} \tSomething went terribly wrong, check ${_ELOG}...\n"
  exit 1
fi
}

printf "${_VHEAD} \tLaunching a series of scripts to get you going...\n"
printf "${_VHEAD} \tSit back and relax, we got this!\n"
sleep 5

##################################
# Fix hosts
##################################

printf "${_VHEAD} \tFixing the hostname resolution for this server...\n"
sleep 5
_ELOG=deploy_sethosts.log
${_NSRC}/adm/stage/sethosts.sh &> ${_HOME}/${_ELOG}
err
printf "${_VHEAD} \tServer IP was updated to resolve to hostname: $(hostname).\n"
sleep 5

##################################
# Enable SAS DNS
##################################
  
printf "${_VHEAD} \tEnabling SAS DNS resolution...\n"
sleep 5
cd ${_NSRC}/adm/stage
export ANSIBLE_CONFIG=${_NSRC}/core/ansible.cfg 
ansible-playbook -i ${_PINV} enable.sas.dns.yml &> /dev/null

##################################
# Install OpenLDAP
##################################

printf "${_VHEAD} \tInstalling and configuring OpenLDAP...\n"
sleep 5
_ELOG=deploy_openldap.log
${_NSRC}/adm/openldap/openldap.sh &> ${_HOME}/${_ELOG}
err

##################################
# Run SAS Playbook
##################################

printf "${_VHEAD} \tRunning the Viya Playbook...\n"

if [ -d ${_HOME}/sas_viya_playbook ]; then
  _ELOG=deployment.log
  cd ${_HOME}/sas_viya_playbook
  export ANSIBLE_CONFIG=${_PLAYBOOK}/ansible.cfg
  ansible-playbook -vvv -i ${_VINV} site.yml
  err
  printf "${_VHEAD} \t\tThe deployment of SAS Viya 3.3 is complete...\n"
  printf "${_VHEAD} \tYou may want to review the deployment guide for any post steps.\n"
else
  printf "${_VHEAD} \tViya Playbook is missing...\n"
fi

export ANSIBLE_CONFIG=
