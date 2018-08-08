#!/bin/bash

printf -v arg %q "$1"

if [ -z "$1" ]; then
        printf "You forgot to define your password after the command.\n"
        exit 1
fi

hosts=`cat ~/sshhosts | tr '\n' ' '`
for hst in ${hosts}; do ssh ${hst} "

echo "${arg}" | sudo passwd $USER --stdin
";
printf "\n Added User ${arg} to ${hst} and set password to Welcome1\n"

done
