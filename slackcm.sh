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
    echo -e "Version: $version\n"

    #Install base packages for slackcm to run
    echo "Installing base packages for slackcm: $slackcm_pkgs"
    apt-get install $slackcm_pkgs -y -qq
    echo -e "slackcm packages installed.\n"
    
    #Include slackcm_functions
    source $slackcm_root/lib/functions.bash

    #Obtain server type
    service=`/bin/cat $slackcm_root/hosts.bash | grep $HOSTNAME | cut -d'=' -f1`
    
    #Check if service exists, if not exit
    if [[ -z $service ]]; then
        echo "$2 does not exist in the hosts.bash file. Please add the host to the file in order to proceed."
        exit
    fi
  
    
    #Define actions
    case $1 in 
        run)
            if [[ -z $host ]] ; then
                slackcm_repo
                #Run base and $service services
                for service_type in base $service; do
                    #Include service_type vars
                    source $slackcm_root/service_type/$service_type/$service_type.bash
                 
                    service_pkgs_installs
                    service_files_sync
                    service_config_sync  
                done
                slackcm_cron
                echo -e "\n\nslackcm run complete.\n"
            else
                deploy_repo $host
                echo -e "\n\nslackcm run complete on $host\n"
            fi
        ;;
        #Add additional actions
    esac
}

slackcm_base $1 $2
