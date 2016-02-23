#!/bin/bash

#Slack Configuration Management Tool

#slackcm vars
host=$2
repo="https://github.com/rsslack/slackcm.git"
slackcm_root=/opt/slackcm
slackcm_pkgs=git
slackcm_cron_file=/etc/cron.d/slackcm
version=1.0
date="$(date +'%Y-%m-%d_%H:%M:%S')"


if [[ -z $1 ]]; then
    echo  "Usage:"
    echo  "run <hostname/ip> -- run slackcm on localhost. hostname/ip should only be specified if you want to run slackcm onremote host."
    echo -e "\nExamples:"
    echo  "$0 run"
    echo  "$0 run 50.16.108.76"
    exit 1
fi

slackcm_base()
{
    echo $date
    echo  "Version: $version"
    echo -e "\nVersion: $version"

    echo "Installing base packages for slackcm: $slackcm_pkgs"
    apt-get install $slackcm_pkgs -y -qq
    echo -e "slackcm packages installed.\n"
    
    #include slackcm_functions
    source $slackcm_root/lib/functions.bash

    #Obtain server type
    
    service_type=`/bin/cat $slackcm_root/hosts.bash | grep $HOSTNAME | cut -d'=' -f1`
    
    if [[ -z $service_type ]]; then
        echo "$2 does not exist in the hosts.bash file. Please add the host to the file in order to proceed."
        exit
    fi
  
    #Include service_type vars
    source $slackcm_root/service_type/$service_type/$service_type.bash
    
    #Define actions
    case $1 in 
        run)
            if [[ -z $host ]] ; then
                slackcm_repo
                service_pkgs_installs
                service_files_sync
                service_config_sync  
                slackcm_cron
                echo -e "\n\nslackcm run complete.\n"
            else
                deploy_repo $host
                echo -e "\n\nslackcm run complete on $host\n"
            fi
        ;;
        #Add additional verbs
    esac
}

slackcm_base $1 $2
