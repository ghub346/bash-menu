#!/bin/bash

# Ensure we are running under bash
if [ "$BASH_SOURCE" = "" ]; then
    /bin/bash "$0"
    exit 0
fi

#
# Load bash-menu script
##
# NOTE: Ensure this is done before using
#       or overriding menu functions/variables.
#
. "bash-menu.sh"


################################
## Example Menu Actions
##
## They should return 1 to indicate that the menu
## should continue, or return 0 to signify the menu
## should exit.
################################

servercreds() {

    echo -n "Provide server information."

    echo "Enter IP address of the server."
    read serverip
        
    echo "Provide root password to the server."
    echo $serverip
   
    read -s -p "Password: " PASSWORD

#    read response

#    return 1
}


actionA() {
# If the server ip || password dont exist, call servercreds function


    if [ -z ${serverip} ]
	then	
	      echo "Server IP is not set."
	      servercreds	
	else
	      echo "Next task."
    fi


    echo "Connect to new server."

#    Moved to seperate function.
#    echo "Enter IP address of the server."
#    read serverip
#	
#    echo "Provide root password to the server."
#    echo $serverip
   
#    read -s -p "Password: " PASSWORD


### For this section, check  forlogic options, if host is already in known list, don't execute the command.


    echo -n "bypass SSH key verification for the provided host."

###  Remove existing entries from known_hosts, if exists.

    ssh-keygen -f "/home/baller175/.ssh/known_hosts" -R "$serverip"

### https://www.putorius.net/automatically-accept-ssh-fingerprint.html - method 2 in script.

    ssh-keyscan -H $serverip >> ~/.ssh/known_hosts

#    ssh -o "StrictHostKeyChecking no" $serverip

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

actionB() {
    echo "Initial config, user creation."
    
    sshpass -p $PASSWORD ssh root@$serverip "bash -s" < /home/baller175/apps/devops/auto/scripts-auto-install/0-init-config.sh

    echo -n "Press enter to continue ... "

    read response

    return 1
}

actionC() {
    echo "Install core software packages."


sshpass -p $PASSWORD ssh root@$serverip "bash -s" < /home/baller175/apps/devops/auto/scripts-auto-install/1-install-core-software.sh

    echo -n "Press enter to continue ... "
    read response

    return 1
}

actionD() {
    echo "Install additional software"




PS3="Select additional software to install:  "

select opt in tailscale megacmd docker node quit
do
    case $opt in
        "tailscale")
            echo "Install Tailscale"	
    
      	    sshpass -p $PASSWORD ssh root@$serverip "bash -s" < /home/baller175/apps/devops/auto/scripts-auto-install/software/install-tailscale.sh
      
      ;;
        "megacmd")
                 echo "Install Mega"
      sshpass -p $PASSWORD ssh root@$serverip "bash -s" < /home/baller175/apps/devops/auto/scripts-auto-install/software/install-megacmd.sh

      ;;
        "docker")
           echo "$opt - let's prepare for a lot of compilation";;
        "node")
           echo "$opt - let's prepare for a lot of compilation";;
        "quit")
           echo "We're done"
           break;;
        *)
           echo "Ooops";;
    esac
done

    ### Option's to install Tailscale, Megacmd, ...  Can also check option's,to perform additional task's such as post configuratiom, etc... etc...
    
    read response

    return 1   

}

actionX() {
    return 0
}


################################
## Setup Example Menu
################################

## Menu Item Text
##
## It makes sense to have "Exit" as the last item,
## as pressing Esc will jump to last item (and
## pressing Esc while on last item will perform the
## associated action).
##
## NOTE: If these are not all the same width
##       the menu highlight will look wonky
menuItems=(
    "1. Item 1"
    "2. Item 2"
    "3. Item 3"
    "4. Item 4"
    "B. Item 1"
    "C. Item 2"	
    "Q. Exit  "
)

## Menu Item Actions
menuActions=(
    actionA
    actionB
    actionC
    actionD	
    actionA
    actionB
    actionX
)

## Override some menu defaults
menuTitle=" Demo of bash-menu"
menuFooter=" Enter=Select, Navigate via Up/Down/First number/letter"
menuWidth=60
menuLeft=25
menuHighlight=$DRAW_COL_YELLOW


################################
## Run Menu
################################
menuInit
menuLoop


exit 0
