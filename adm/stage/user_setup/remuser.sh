#!/bin/bash

printf -v arg %q "$1"

hosts=`cat ~/sshhosts | tr '\n' ' '`
for hst in ${hosts}; do ssh ${hst} "

sudo userdel -r ${arg}";
printf "\n Deleted User ${arg} from ${hst}\n"

done
