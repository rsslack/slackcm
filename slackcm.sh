#!/bin/bash

#Slack Configuration Management Tool

#slackcm vars
version=1.0
slackcm_root=/opt/slackcm
slackcm_pkgs=git
slackcm_cron_file=/etc/init.d/slackcm
slackcm_repo="https://github.com/rsslack/slackcm.git"
host=$2


if [[ -z $1 ]]; then
    echo  "Version: $version"
    echo  "Usage:"
    echo  "run -- run slackcm on localhost"
    echo  "deploy <hostname/ip> -- run slackcm on a remote host."
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
    
    service_type=`/bin/cat $slackcm_root/hosts.bash | grep $HOSTNAME | cut -d'=' -f1`
  
    #Include service_type vars
    source $slackcm_root/service_type/$service_type/$service_type.bash
    
    #Define actions
    case $1 in 
        run)
            #git commands
            service_pkgs_installs
            service_files_sync
            service_config_sync  
            slackcm_cron
        ;;
        deploy)
            slackcm_cron
        ;;
    esac
    

}

slackcm_base $1 $2
