#!/bin/bash

host=`hostname`
ON=0

# -- CREATE USER FUNCTION --
function createu() {
	sudo adduser $1
	sudo usermod -a -G sas $1 
	echo "Welcome1" | sudo passwd $1 --stdin
}

function createkey() {
	 user="$1"_key
	 sudo -u $1 ssh-keygen -t rsa -N "" -f /home/$1/.ssh/id_rsa
	 sudo -u $1 cp /home/$1/.ssh/id_rsa.pub /home/$1/.ssh/authorized_keys
	 sudo -u $1 sed -i "s/$1@$host/$user/g" /home/$1/.ssh/authorized_keys
	 sudo -u $1 cp /home/$1/.ssh/id_rsa /tmp/keys/$1_key.pem
}

function newpass() {
	sudo chage -d 0 $1
}

# -- BSP USER LIST --
if [ "$ON" -ne 0 ]; then
	createu willwo # Scott Wood
	createu ninewb # Nick Newbill
	createu rywend # Ryan Wendt
	createu jevand # Jeff Van Domlin
	createu srpare # Sridhar Parepali
	createu hegood # Heather Goodykoontz
	createu saaran # Sanjay Arangala
	createu dakuhn # David Kuhn
	createu scnewk # Steve Newkirk
fi 

if [ "$ON" -ne 0 ]; then
	createkey ninewb
	createkey willwo # Scott Wood
	createkey rywend # Ryan Wendt
	createkey jevand # Jeff Van Domlin
	createkey srpare # Sridhar Parepali
	createkey hegood # Heather Goodykoontz
	createkey saaran # Sanjay Arangala
	createkey dakuhn # David Kuhn
	createkey scnewk # Steve Newkirk
fi

newpass willwo # Scott Wood
newpass ninewb # Nick Newbill
newpass rywend # Ryan Wendt
newpass jevand # Jeff Van Domlin
newpass srpare # Sridhar Parepali
newpass hegood # Heather Goodykoontz
newpass saaran # Sanjay Arangala
newpass dakuhn # David Kuhn
newpass scnewk # Steve Newkirk
