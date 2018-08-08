#!/bin/bash

printf -v arg %q "$1"
printf -v arg2 %q "$2"

if [ -z "$2" ]; then
        printf "You forgot to include the uid.\n"
        printf "Example: ./adduser.sh johndoe 3000\n"
        exit 1
fi

hosts=`cat ~/sshhosts | tr '\n' ' '`
for hst in ${hosts}; do ssh ${hst} "

sudo useradd -u ${arg2} ${arg}
sudo usermod -a -G sas ${arg}
echo "Welcome1" | sudo passwd ${arg} --stdin
";
printf "\n Added User ${arg} to ${hst} and set password to Welcome1\n"

done
