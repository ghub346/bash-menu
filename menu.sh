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

inituser() {

    if [ -z ${serverip} ]
	then	
	      echo "Server IP is not set."
	      servercreds	
	else
	      echo "Next task."
    fi


    echo "Initial config, user creation."
    
    sshpass -p $PASSWORD ssh root@$serverip "bash -s" < /home/baller175/apps/devops/auto/scripts-auto-install/0-init-config.sh

    echo -n "Press enter to continue ... "

    read response

    return 1

}

targetconnect() {


declare -a saisoft

for script in /home/baller175/apps/devops/auto/scripts-auto-install/software/*.sh
do
    saisoft=(${saisoft[*]} "$script")
done

for item in "${!saisoft[@]}"
do
#  echo " index---------------content"
  echo " $item                  ${saisoft[$item]}"

    
#    echo "ITEM: *** $item ***"
done


select soft in Tailscale MegaCMD Docker Hestia
do

case $soft in
# Two case values are declared here for matching
"Tailscale")
echo "I also use $soft."
sshpass -p $PASSWORD ssh root@$serverip "/bin/bash -s" < "${saisoft[14]}"
;;

# Three case values are declared here for matching
"MegaCMD")
echo "Why don't you try Linux?"
sshpass -p $PASSWORD ssh root@$serverip "/bin/bash -s" < "${saisoft[7]}"
;;

# Three case values are declared here for matching	
"Docker")
echo "Why don't you try Linux?"
sshpass -p $PASSWORD ssh root@$serverip "/bin/bash -s" < "${saisoft[4]}"
;;

# Three case values are declared here for matching	
"Hestia")
echo "Why don't you try Linux?"
sshpass -p $PASSWORD ssh root@$serverip "/bin/bash -s" < "${saisoft[6]}"
;;



# Matching with invalid data
*)
echo "Invalid entry."
break
;;
esac

done



#	sshpass -p $PASSWORD ssh root@$serverip "/bin/bash -s" < "${saisoft[13]}"

        echo -n "Press enter to continue ... "
        read response

        return 1

}

softscripts() {
declare -a saisoft

for script in /home/baller175/apps/devops/auto/scripts-auto-install/software/*.sh
do
    saisoft=(${saisoft[*]} "$script")
done

for item in "${!saisoft[@]}"
do
  echo " index---------------content"
  echo " $item                  ${saisoft[$item]}"

    
    echo "ITEM: *** $item ***"
done

        echo -n "Press enter to continue ... "
        read response

        return 1

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


items=(1 "Initiate Connection"
       2 "Initial User setup"
       3 "Item 3"
       4 "Install Softwares")

while choice=$(dialog --title "$TITLE" \
                 --menu "Please select" 10 40 3 "${items[@]}" \
                 2>&1 >/dev/tty)
    do
    case $choice in
        1) initconnect
        ;; # some action on 1
        2) inituser
	;; # some action on 2
 	3) softscripts
	;;
 	4) targetconnect
	;;
        *) ;; # some action on other
    esac
done
clear # clear after user pressed Cancel
