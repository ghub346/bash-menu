#!/bin/bash

# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi


# Functions declarations.
servercreds() {

    echo -n "Provide server information."

    echo "Enter IP address of the server."
    read serverip
        
    echo "Provide root password to the server."
    echo $serverip
   
    read -s -p "Password: " PASSWORD

}


# Make initial connection automatically.

# If the server ip || password dont exist, call servercreds function

initconnect() {
    if [ -z ${serverip} ]
	then	
	      echo "Server IP is not set."
	      servercreds	
	else
	      echo "Next task."
    fi


    echo "Attempting first connection to the new server."

    echo -n "Checking SSH key verification for the provided host."

    ssh-keygen -f "/home/baller175/.ssh/known_hosts" -R "$serverip"

### https://www.putorius.net/automatically-accept-ssh-fingerprint.html - method 2 in script.

    ssh-keyscan -H $serverip >> ~/.ssh/known_hosts
    echo -n "Testing connection to the server"

    sshpass -p $PASSWORD ssh -q root@$serverip exit


### If the result is successful , value returned will be 0.
    echo $?

    if [ $? -ne 0 ]
	then
    echo "The connection failed, check manually."
	else
  echo "Connection successfully established."
fi



    echo -n " "	

    echo -n "Press enter to continue ... "
    read response

    return 1
}


items=(1 "Item 1"
       2 "Item 2")

while choice=$(dialog --title "$TITLE" \
                 --menu "Please select" 10 40 3 "${items[@]}" \
                 2>&1 >/dev/tty)
    do
    case $choice in
        1) interconnect
        ;; # some action on 1
        2) ;; # some action on 2
        *) ;; # some action on other
    esac
done
clear # clear after user pressed Cancel