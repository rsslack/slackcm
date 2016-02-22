#!/bin/bash

#Defined functions for slackcm


#Install service packages
service_pkgs_installs()
{
    echo -e "\nInstall $service_type packages: $service_pkgs"
    /usr/bin/apt-get install $service_pkgs -qq -y
    echo -e "$service_type packages installed."
}

#slackcm sync function
service_files_sync()
{
    if [[ $service_copy_files = 1 ]]; then
    	echo -e "\nCopying $service_type files:"
        /usr/bin/rsync -a --no-perms $slackcm_root/service_type/$service_type/files/* /.
        echo -e "$service_type files copy complete."
    else
        echo -e "\nservice_copy_files var isn't defined in $slackcm_root/service_type/$service_type/$service_type.bash. If you would like to copy files for $service_type, add \"service_copy_files=1\" in $service_type.bash.\n"    
    fi 
}


service_config_sync()
{
    if [[ $service_copy_config = 1 ]]; then
        
        #Check if the config exists on the server
        if [[ -f $slackcm_root/service_type/$service_type/config/$service_config ]]; then
            
            #Config exists. Now do check if the config is the same
            if [[ `md5sum < $slackcm_root/service_type/$service_type/config/$service_config` = `md5sum < $service_config_dir/$service_config` ]]; then
                echo -e "\nThe config on the server is the same as the config on the repo."
            else 
                echo "The config is different from the repo. Copying $service_type config."
                /usr/bin/rsync -a --no-perms $slackcm_root/service_type/$service_type/config/$service_config $service_config_dir
                restart_app=1
                echo "$service_type config copy complete."
             fi
        else
                echo "The config doesn't exist on the server. Copying $service_type config."
                /usr/bin/rsync -a --no-perms $slackcm_root/service_type/$service_type/config/$service_config $service_config_dir
                restart_app=1
                echo "$service_type config copy complete."
        fi 
        if [[ $service_auto_restart = 1 ]] && [[ $restart_app = 1 ]]; then
            #Automatically restart the service
            /usr/sbin/service $service_name restart
        elif [[ $service_auto_restart != 1 ]] && [[ $restart_app = 1 ]]; then
             echo "$service_name wasn't automatically restarted because service_auto_restart var wasn't defined. $service_name needs to be restarted before the new config changes take effect."
        fi
    else
        echo -e "\nservice_copy_config var isn't defined in $slackcm_root/service_type/$service_type/$service_type.bash. If you would like to copy config for $service_type, add \"service_config=1\" in $service_type.bash.\n"    
    fi 
}

slackcm_cron()
{
    #Copy slackcm cron
    /usr/bin/rsync -av -qq --no-perms $slackcm_root/slackcm_files/slackcm-cron $slackcm_cron_file
}
