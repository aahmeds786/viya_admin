#!/bin/bash

# This script has settings specific to SAS Viya 3.3.
# Script Version 0.5

## TODO:
# Review static requirements and update version specifics
# Review 3.2 requirements and look into 3.4 for changes
# Add additional requirements that are missing
# Update the details for service shutdown in cron

SFT_NOFILE=
STK_NOFILE=
HRD_NPROC=

INSTALL=/install
GVLOG=/tmp/goviya.log

# --------------------------------------------------------
# Static Variables
# --------------------------------------------------------

VC=$(tput setaf 45)
RED=$(tput setaf 1)
NORM=$(tput sgr0)

HEAD="[ ${VC}SAS VIYA${NORM} ]"
GVERR=${RED}ERROR:${NORM}

# --------------------------------------------------------

help() {
  printf "\n\n"
  printf "This script assumes you have root or sudo access...\n\n"
  printf "This script has various checks meant to help assist with the pre-reqiusites for \n"
  printf "SAS Viya.  This script was initially setup to stage AWS systems for quick deployemnt. \n"
  printf "Please note that this script is not for everyone, and depending on your environemnt \n"
  printf "makeup, issues could occur.\n\n"
  printf "This script was developed around SAS Viya 3.3."
  printf "\n"
  printf "\t Usage: $0 [options]" >&2
  printf "\n\n"
  printf "      -h         :   this help interface \n"
  printf "      -c         :   if this is a SAS Visual Investigator deployment \n"
  printf "      -p         :   remove a previously created git repository \n"
  printf "\n"
  exit 1
}

function pre() {
  PKG_VIYA="glibc libpng12 libXp libXmu net-tools numactl xorg-x11-xauth xterm"
  PKG_VI="gettext bc"
  PKG_XTRA="openldap* migrationtools exportfs"
  ANSIBLE_VER=2.3.2
  KERN_SEM=512 32000 256 1024
  NET_CORE=2048

# -- Checks if root
if [ "$EUID" -ne 0 ]; then
  printf "${HEAD} \tPre-installation tasks expect root or sudo access. \n\n"
fi

# --------------------------------------------------------
# Initialization
# --------------------------------------------------------

printf "${HEAD} \tInstalling software packages... \n"
sudo yum -y install ${PKG_VIYA} ${PKG_VI} ${PKG_XTRA} > ${GVLOG} && sudo yum -y update systemd > ${GVLOG}
if [ $? -ne 0 ]; then
  printf "${HEAD} \t${GVERR}  Package installs had an error, review the log: ${GVLOG}\n\n"
  exit 1
else
  printf "${HEAD} \tRequired packages were installed or updated successfully.\n"
fi

# -- jq 1.5 is required
printf "${HEAD} \tAcquiring JQ package... \n"
curl -s -S -L -o jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ./jq && sudo cp jq /usr/bin > ${GVLOG}
if [ $? -ne 0 ]; then
  printf "${HEAD} \t${GVERR}  Package install had an error, review the log: ${GVLOG}\n\n"
  exit 1
else
  printf "${HEAD} \tJQ was installed or updated successfully.\n"
fi

# --------------------------------------------------------
# SELINUX
# --------------------------------------------------------

sudo setenforce 0; sudo sed -i.bak -e 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/selinux/config > ${GVLOG}
if [ $? -ne 0 ]; then
  printf "${HEAD} \t${GVERR}  Package installs had an error, review the log: ${GVLOG}\n\n"
  exit 1
else
  printf "${HEAD} \tSELINUX was set to permissive.\n"
fi

# ---------------------------------
# ulimits
# ---------------------------------

echo "*		-	nofile		${SFT_NOFILE}" | sudo tee -a /etc/security/limits.conf
echo "*		-	nofile		${STK_NOFILE}" | sudo tee -a /etc/security/limits.conf
echo "*		-	nproc		${HRD_NPROC}" | sudo tee -a /etc/security/limits.d/20-nproc.conf


}


# --------------------------------------------------------
# Check Password-less SSH
# --------------------------------------------------------

function pwssh() {
hosts=`cat ${envhosts} | tr '\n' ' '`
for hst in ${hosts}; do ssh ${hst} "
        printf "${HEAD} \t From: $(hostname) \n"
        printf "${HEAD} \t Connect as $(whoami) to:" ; for hst2 in ${hosts} ; do ssh -o StrictHostKeyChecking=no \${hst2} 'echo \`hostname\`  '  ;done
         "; done
}
# -- Version decision tree
while getopts "hpc" opt; do
case "${opt}" in

        h)
            help
            break ;;
        p)
            pre
            break ;;
        c)
            pwssh
            break ;;
        *)   printf "${HEAD} \t You have entered an incorrect version. \n"
             continue  ;;
        esac
done


# --------------------------------------------------------
# Service Shutdown
# --------------------------------------------------------

# Need to add so we can update
#CRON_TZ="America/Indiana/Indianapolis"
#0 18 * * * /sbin/service sas-viya-all-services stop
