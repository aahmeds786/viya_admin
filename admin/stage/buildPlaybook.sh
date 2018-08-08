#!/bin/bash



if [ -f ${_HOME}/SAS_Viya_playbook.tgz ] ; then
  printf "${_VHEAD} \tRemoving old playbook file...\n"  
  rm -r ${_HOME}/SAS_Viya_playbook.tgz
fi

if [ -d ${_PLAYBOOK} ] ; then
  printf "${_VHEAD} \tBacking up and removing old playbook directory...\n"  
  tar -cvf ${_HOME}/sas_viya_playbook_old.tar ${_PLAYBOOK}/*
  rm -rf ${_PLAYBOOK}
fi

if [ ! -f ${_HOME}/sas-orchestration ]; then
  echo "Downloading sas-orchestration utility ...."
  curl -o ${_HOME}/sas-orchestration https://support.sas.com/installation/viya/sas-orchestration-cli/lax/sas-orchestration.tgz  
  tar -xf ${_HOME}/sas-orchestration
  chmod +x ${_HOME}/sas-orchestration
fi

if [ -f ${_HOME}/SAS_Viya_deployment_data.zip ] ; then
   ${HOME}/sas-orchestration build --input SAS_Viya_deployment_data.zip

   if [ -f ${_HOME}/SAS_Viya_playbook.tgz ] ; then
      echo "Extracting playbook"
      tar -xvf ${_HOME}/SAS_Viya_playbook.tgz

   else
      echo "n Orchestration Build failed"
   fi
else
   echo "No SAS Order Present ... downloading ..."
   curl -o ${_HOME}/SAS_Viya_deployment_data.zip http://spsweb.unx.sas.com:8400/COMSAT/orders/09/LR/09MJV3/soe/SAS_Viya_deployment_data.zip
   echo "Please verify your order has downloaded and re-run this script."
   
fi
