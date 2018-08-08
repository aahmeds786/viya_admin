#!/bin/bash

# -- CREATE USER FUNCTION --
function createu() {
	sudo adduser $1
	sudo usermod -a -G sas $1 
	echo "Welcome1" | sudo passwd $1 --stdin
}

# -- SET INITIAL PASSWORD
function newpass() {
	sudo chage -d 0 $1
}

createu $1
newpass $1
