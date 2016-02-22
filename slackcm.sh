#!/bin/bash

#Slack Configuration Management Tool

#slackcm vars
version=1.0
slackcm_root=/opt/slackcm
slackcm_pkgs=git


if [[ -z $1 ]]; then
    echo  "Version: $version"
    echo  "Usage:"
    echo  "run -- run slackcm on localhost"
    echo  "deploy <hostname/ip> (ssh_username) -- run slackcm on a remote host. ssh_username is optional (default user is root)."
    echo -e "\nExamples:"
    echo  "$0 run"
    echo  "$0 deploy 50.16.108.76"
    exit 1
fi

slackcm_base()
{
    echo "Version: $version"

    echo "Installing base packages: $slackcm_pkgs"
    #apt-get update -qq
    apt-get install $slackcm_pkgs -y -qq
    echo "Packages installed."
    
    #include slackcm_functions
    source $slackcm_root/lib/functions.bash

    #Obtain server type
    server_type=`cat hosts.bash | grep $HOSTNAME | cut -d'=' -f1`
  
    #Include server_type vars
    source $slackcm_root/server_type/$server_type/$server_type.bash
    
    echo $server_type

    #Define actions
    case $1 in 
        run)
            #git commands
            slackcm_server_type_installs
            slackcm_sync_files
            slackcm_sync_config
        ;;
        deploy)
            slackcm_sync
        ;;
    esac
    

}

slackcm_base $1
