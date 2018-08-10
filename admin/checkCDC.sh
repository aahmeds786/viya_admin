#!/bin/bash
#===========================================================================================================
#
#          SCRIPT: checkCDC.sh
#     DESCRIPTION: This script can
#
#           USAGE: checkCDC.sh <user>
#                  $1 - User whos session your checking.
#
#===========================================================================================================
#
#    USER OPTIONS:

showtables=false
_cdc=/opt/sas/cas_cache

#===========================================================================================================

function checkCDC() {
userid=$1

sessionPID=`ps -u ${userid} -o user:12,pid,ppid,stime,cmd | /usr/bin/grep cas | grep -v grep | awk '{print $2}'`
masterPID=`ps -u cas -o user:12,pid,ppid,stime,cmd | grep "cas join" | awk '{print $2}'`
buffcache=`free -m | grep Mem | awk '{print $6}'`
casdisk=`df -m ${_cdc} | grep -v Used | awk '{print $3}'`

printf " ----------------------------------------------\n"
printf "\t -- CAS_DISK_CACHE Usage Script --\n"
printf " ----------------------------------------------\n"

printf "${_VHEAD} \t Your userid: ${userid} \n"
printf "${_VHEAD} \t Your CAS session PID on ${host}: ${sessionPID} \n"
printf "${_VHEAD} \t The master CAS session PID: ${masterPID} \n"

printf "${_VHEAD} \t Buffer Cache used: ${buffcache} MB\n"
printf "${_VHEAD} \t CAS_DISK_CACHE used [${_cdc}]: ${casdisk} MB\n"

printf "${_VHEAD} \t Session CAS tables: # files in CAS_DISK_CACHE: "
sudo -u $userid lsof -a +L1 -p ${sessionPID} | grep _${sessionPID}_ | wc -l
printf "\n"

printf "${_VHEAD} \t Global CAS tables created in this CAS session: # files in CAS_DISK_CACHE: "
sudo -u cas lsof -a +L1 -p ${masterPID} | grep _${sessionPID}_ | wc -l
printf "\n"

if [ ${showtables} == true ]; then
	printf "${_VHEAD} \t Session CAS tables: files in CAS_DISK_CACHE \n"
	sudo lsof -a +L1 -p ${sessionPID} | grep _${sessionPID}_
fi

if [ ${showtables} == true ]; then
	printf "${_VHEAD} \t Global CAS tables created in this CAS session: files in CAS_DISK_CACHE \n"
	sudo -u cas lsof -a +L1 -p ${masterPID} | grep _${sessionPID}_
fi


}

if rpm -qa | grep lsof  2>&1 > /dev/null; then
	checkCDC
else
	printf "The package lsof is not installed and required for operation of this script."
fi

# echo "***Try this if you want a real-time view of CAS_DISK_CACHE file: lsof -a +L1 -p ${sessionPID} -r1"
